import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/format/date_label.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_row_menu.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_search_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_select_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:primelayer_admin_panel/features/print_queue/domain/print_job.dart';
import 'package:primelayer_admin_panel/features/print_queue/domain/print_job_status.dart';
import 'package:primelayer_admin_panel/features/print_queue/presentation/cubit/print_queue_cubit.dart';
import 'package:primelayer_admin_panel/features/print_queue/presentation/cubit/print_queue_state.dart';

class PrintQueueView extends StatelessWidget {
  const PrintQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrintQueueCubit, PrintQueueState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<PrintQueueCubit>().clearNotice();
      },
      child: BlocBuilder<PrintQueueCubit, PrintQueueState>(
        builder: (context, state) {
          final items = state.pagedJobs;
          return AdminListScaffold(
            title: 'Print queue',
            subtitle: 'Jobs mapped to orders on the print floor.',
            actions: [
              ElevatedButton.icon(
                onPressed: () => _queueFromOrder(context),
                icon: const Icon(Icons.add),
                label: const Text('Queue job'),
              ),
            ],
            stats: _stats(state),
            filters: [
              AdminSearchField(
                hint: 'Search by order, product, or printer',
                onChanged: context.read<PrintQueueCubit>().searchChanged,
              ),
              AdminSelectField(
                label: 'Status',
                value: state.status?.name ?? 'all',
                options: [
                  const AdminSelectOption(value: 'all', label: 'All statuses'),
                  for (final value in PrintJobStatus.values)
                    AdminSelectOption(value: value.name, label: value.label),
                ],
                onChanged: (value) {
                  context.read<PrintQueueCubit>().statusChanged(
                    value == 'all'
                        ? null
                        : PrintJobStatus.values.firstWhere(
                            (item) => item.name == value,
                          ),
                  );
                },
              ),
            ],
            columns: const [
              AdminTableColumn(label: 'Order'),
              AdminTableColumn(label: 'Product', flex: 2),
              AdminTableColumn(label: 'Printer'),
              AdminTableColumn(label: 'Queued on', flex: 2),
              AdminTableColumn(label: 'Status'),
              AdminTableColumn(label: 'Actions', flex: 1),
            ],
            rowCount: items.length,
            cells: (index) => _cells(context, items[index]),
            emptyLabel: 'No matching jobs',
            page: state.safePage,
            total: state.filteredJobs.length,
            onPageChanged: context.read<PrintQueueCubit>().pageChanged,
          );
        },
      ),
    );
  }

  List<AdminStatMetric> _stats(PrintQueueState state) {
    var queued = 0;
    var printing = 0;
    var failed = 0;
    var done = 0;
    for (final job in state.jobs) {
      switch (job.status) {
        case PrintJobStatus.queued:
          queued += 1;
        case PrintJobStatus.printing:
          printing += 1;
        case PrintJobStatus.failed:
          failed += 1;
        case PrintJobStatus.done:
          done += 1;
        case PrintJobStatus.paused:
          break;
      }
    }
    return [
      AdminStatMetric(
        label: 'Queued',
        value: '$queued',
        caption: 'Waiting',
        icon: Icons.hourglass_empty,
        tone: AdminChipTone.pending,
      ),
      AdminStatMetric(
        label: 'Printing',
        value: '$printing',
        caption: 'Active',
        icon: Icons.print_outlined,
        tone: AdminChipTone.info,
      ),
      AdminStatMetric(
        label: 'Failed',
        value: '$failed',
        caption: 'Need retry',
        icon: Icons.error_outline,
        tone: AdminChipTone.danger,
      ),
      AdminStatMetric(
        label: 'Done',
        value: '$done',
        caption: 'Finished',
        icon: Icons.check_circle_outline,
        tone: AdminChipTone.success,
      ),
    ];
  }

  List<Widget> _cells(BuildContext context, PrintJob job) {
    return [
      AdminTextCell(job.orderNumber, emphasis: true),
      AdminTextCell(job.productName),
      AdminTextCell(job.printer),
      AdminTextCell(DateLabel.of(job.queuedAt)),
      StatusChip(label: job.status.label, tone: _tone(job.status)),
      AdminRowMenu(
        onSelected: (value) {
          context.read<PrintQueueCubit>().updateStatus(
            job.id,
            PrintJobStatus.values.firstWhere((item) => item.name == value),
          );
        },
        items: [
          for (final value in PrintJobStatus.values)
            PopupMenuItem(value: value.name, child: Text(value.label)),
        ],
      ),
    ];
  }

  AdminChipTone _tone(PrintJobStatus status) {
    return switch (status) {
      PrintJobStatus.queued => AdminChipTone.pending,
      PrintJobStatus.printing => AdminChipTone.info,
      PrintJobStatus.paused => AdminChipTone.muted,
      PrintJobStatus.failed => AdminChipTone.danger,
      PrintJobStatus.done => AdminChipTone.success,
    };
  }

  void _queueFromOrder(BuildContext context) {
    final orders = context.read<OrdersCubit>().state.orders;
    if (orders.isEmpty) return;
    ShopOrder? selected = orders.first;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Queue from order'),
          content: DropdownButtonFormField<String>(
            initialValue: selected!.id,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Order'),
            items: [
              for (final order in orders)
                DropdownMenuItem(
                  value: order.id,
                  child: Text('${order.number} · ${order.items.first.name}'),
                ),
            ],
            onChanged: (value) {
              selected = orders.firstWhere((item) => item.id == value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final order = selected!;
                context.read<PrintQueueCubit>().save(
                  PrintJob(
                    id: 'pq-${DateTime.now().microsecondsSinceEpoch}',
                    orderId: order.id,
                    orderNumber: order.number,
                    productName: order.items.first.name,
                    printer: 'Alpha',
                    status: PrintJobStatus.queued,
                    queuedAt: DateTime.now(),
                  ),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Queue'),
            ),
          ],
        );
      },
    );
  }
}

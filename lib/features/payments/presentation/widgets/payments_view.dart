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
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment_status.dart';
import 'package:primelayer_admin_panel/features/payments/presentation/cubit/payments_cubit.dart';
import 'package:primelayer_admin_panel/features/payments/presentation/cubit/payments_state.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentsCubit, PaymentsState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<PaymentsCubit>().clearNotice();
      },
      child: BlocBuilder<PaymentsCubit, PaymentsState>(
        builder: (context, state) {
          final items = state.pagedPayments;
          return AdminListScaffold(
            title: 'Payments',
            subtitle: 'Track collections mapped to orders and customers.',
            stats: _stats(state),
            filters: [
              AdminSearchField(
                hint: 'Search by order number or payment ID',
                onChanged: context.read<PaymentsCubit>().searchChanged,
              ),
              AdminSelectField(
                label: 'Status',
                value: state.status?.name ?? 'all',
                options: [
                  const AdminSelectOption(value: 'all', label: 'All statuses'),
                  for (final value in PaymentStatus.values)
                    AdminSelectOption(value: value.name, label: value.label),
                ],
                onChanged: (value) {
                  context.read<PaymentsCubit>().statusChanged(
                    value == 'all'
                        ? null
                        : PaymentStatus.values.firstWhere(
                            (item) => item.name == value,
                          ),
                  );
                },
              ),
            ],
            columns: const [
              AdminTableColumn(label: 'Payment'),
              AdminTableColumn(label: 'Order'),
              AdminTableColumn(label: 'Customer', flex: 2),
              AdminTableColumn(label: 'Method'),
              AdminTableColumn(label: 'Amount'),
              AdminTableColumn(label: 'Paid on', flex: 2),
              AdminTableColumn(label: 'Status'),
              AdminTableColumn(label: 'Actions', flex: 1),
            ],
            rowCount: items.length,
            cells: (index) => _cells(context, items[index]),
            emptyLabel: 'No matching payments',
            page: state.safePage,
            total: state.filteredPayments.length,
            onPageChanged: context.read<PaymentsCubit>().pageChanged,
          );
        },
      ),
    );
  }

  List<AdminStatMetric> _stats(PaymentsState state) {
    var paid = 0;
    var pending = 0;
    var refunded = 0;
    for (final payment in state.payments) {
      switch (payment.status) {
        case PaymentStatus.paid:
          paid += 1;
        case PaymentStatus.pending:
          pending += 1;
        case PaymentStatus.refunded:
          refunded += 1;
        case PaymentStatus.failed:
          break;
      }
    }
    return [
      AdminStatMetric(
        label: 'Total payments',
        value: '${state.payments.length}',
        caption: 'Recorded',
        icon: Icons.payments_outlined,
      ),
      AdminStatMetric(
        label: 'Paid',
        value: '$paid',
        caption: 'Collected',
        icon: Icons.check_circle_outline,
        tone: AdminChipTone.success,
      ),
      AdminStatMetric(
        label: 'Pending',
        value: '$pending',
        caption: 'Awaiting',
        icon: Icons.schedule_outlined,
        tone: AdminChipTone.pending,
      ),
      AdminStatMetric(
        label: 'Refunded',
        value: '$refunded',
        caption: 'Returned',
        icon: Icons.undo_outlined,
        tone: AdminChipTone.danger,
      ),
    ];
  }

  List<Widget> _cells(BuildContext context, Payment payment) {
    final customer = context.read<CustomersCubit>().state.nameFor(
      payment.customerId,
    );
    return [
      AdminTextCell(payment.id, emphasis: true),
      AdminTextCell(payment.orderNumber),
      AdminTextCell(customer),
      AdminTextCell(payment.method.label),
      AdminTextCell(payment.amountLabel),
      AdminTextCell(DateLabel.of(payment.paidAt)),
      StatusChip(label: payment.status.label, tone: _tone(payment.status)),
      AdminRowMenu(
        onSelected: (value) {
          context.read<PaymentsCubit>().updateStatus(
            payment.id,
            PaymentStatus.values.firstWhere((item) => item.name == value),
          );
        },
        items: [
          for (final value in PaymentStatus.values)
            PopupMenuItem(value: value.name, child: Text(value.label)),
        ],
      ),
    ];
  }

  AdminChipTone _tone(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.paid => AdminChipTone.success,
      PaymentStatus.pending => AdminChipTone.pending,
      PaymentStatus.refunded => AdminChipTone.muted,
      PaymentStatus.failed => AdminChipTone.danger,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_row_menu.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/confirm_delete_dialog.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_state.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/widgets/shipping_editor_dialog.dart';

class ShippingView extends StatelessWidget {
  const ShippingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShippingCubit, ShippingState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<ShippingCubit>().clearNotice();
      },
      child: BlocBuilder<ShippingCubit, ShippingState>(
        builder: (context, state) {
          var active = 0;
          var free = 0;
          for (final method in state.methods) {
            if (method.isActive) active += 1;
            if (method.price == 0) free += 1;
          }
          return AdminListScaffold(
            title: 'Shipping',
            subtitle: 'Delivery methods used by website checkout and orders.',
            actions: [
              ElevatedButton.icon(
                onPressed: () => ShippingEditorDialog.open(context),
                icon: const Icon(Icons.add),
                label: const Text('Add method'),
              ),
            ],
            stats: [
              AdminStatMetric(
                label: 'Methods',
                value: '${state.methods.length}',
                caption: 'Configured',
                icon: Icons.local_shipping_outlined,
              ),
              AdminStatMetric(
                label: 'Active',
                value: '$active',
                caption: 'Offered',
                icon: Icons.check_circle_outline,
                tone: AdminChipTone.success,
              ),
              AdminStatMetric(
                label: 'Inactive',
                value: '${state.methods.length - active}',
                caption: 'Hidden',
                icon: Icons.pause_circle_outline,
                tone: AdminChipTone.muted,
              ),
              AdminStatMetric(
                label: 'Free',
                value: '$free',
                caption: 'Zero fee',
                icon: Icons.savings_outlined,
                tone: AdminChipTone.info,
              ),
            ],
            columns: const [
              AdminTableColumn(label: 'Method', flex: 2),
              AdminTableColumn(label: 'ETA'),
              AdminTableColumn(label: 'Price'),
              AdminTableColumn(label: 'Status'),
              AdminTableColumn(label: 'Actions', flex: 1),
            ],
            rowCount: state.methods.length,
            cells: (index) => _cells(context, state.methods[index]),
            onRowTap: (index) => ShippingEditorDialog.open(
              context,
              method: state.methods[index],
            ),
            emptyLabel: 'No shipping methods',
            page: 0,
            total: state.methods.length,
            onPageChanged: (_) {},
          );
        },
      ),
    );
  }

  List<Widget> _cells(BuildContext context, ShippingMethod method) {
    return [
      AdminTextCell(method.name, emphasis: true),
      AdminTextCell(method.eta),
      AdminTextCell(method.priceLabel),
      StatusChip(
        label: method.isActive ? 'Active' : 'Inactive',
        tone: method.isActive ? AdminChipTone.success : AdminChipTone.muted,
      ),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              ShippingEditorDialog.open(context, method: method);
            case 'toggle':
              context.read<ShippingCubit>().toggleActive(method.id);
            case 'delete':
              ConfirmDeleteDialog.open(
                context,
                title: 'Delete ${method.name}?',
                message: 'This cannot be undone.',
                onConfirm: () =>
                    context.read<ShippingCubit>().delete(method.id),
              );
          }
        },
        items: [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(
            value: 'toggle',
            child: Text(method.isActive ? 'Deactivate' : 'Activate'),
          ),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ];
  }
}

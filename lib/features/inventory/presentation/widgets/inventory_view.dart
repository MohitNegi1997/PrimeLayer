import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_search_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_select_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/inventory/domain/inventory_mapper.dart';
import 'package:primelayer_admin_panel/features/inventory/domain/inventory_row.dart';
import 'package:primelayer_admin_panel/features/inventory/presentation/cubit/inventory_cubit.dart';
import 'package:primelayer_admin_panel/features/inventory/presentation/cubit/inventory_state.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_state.dart';
import 'package:primelayer_admin_panel/features/settings/presentation/cubit/settings_cubit.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final threshold =
        context.watch<SettingsCubit>().state.settings.lowStockThreshold;

    return BlocListener<ProductsCubit, ProductsState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<ProductsCubit>().clearNotice();
      },
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, productsState) {
          return BlocBuilder<InventoryCubit, InventoryState>(
            builder: (context, state) {
              final rows = InventoryMapper.fromProducts(productsState.products);
              final filtered = state.filtered(rows, threshold: threshold);
              final items = state.paged(rows, threshold: threshold);
              var low = 0;
              var empty = 0;
              for (final row in rows) {
                if (row.stock == 0) empty += 1;
                if (row.stock <= threshold) low += 1;
              }
              return AdminListScaffold(
                title: 'Inventory',
                subtitle: 'Stock levels mapped to product variants.',
                stats: [
                  AdminStatMetric(
                    label: 'SKUs',
                    value: '${rows.length}',
                    caption: 'Tracked',
                    icon: Icons.warehouse_outlined,
                  ),
                  AdminStatMetric(
                    label: 'Low stock',
                    value: '$low',
                    caption: '≤ $threshold units',
                    icon: Icons.warning_amber_outlined,
                    tone: AdminChipTone.pending,
                  ),
                  AdminStatMetric(
                    label: 'Out of stock',
                    value: '$empty',
                    caption: 'Need reprint',
                    icon: Icons.inventory_outlined,
                    tone: AdminChipTone.danger,
                  ),
                  AdminStatMetric(
                    label: 'Healthy',
                    value: '${rows.length - low}',
                    caption: 'Above alert',
                    icon: Icons.check_circle_outline,
                    tone: AdminChipTone.success,
                  ),
                ],
                filters: [
                  AdminSearchField(
                    hint: 'Search SKU or product',
                    onChanged: context.read<InventoryCubit>().searchChanged,
                  ),
                  AdminSelectField(
                    label: 'Stock',
                    value: state.lowStockOnly ? 'low' : 'all',
                    options: const [
                      AdminSelectOption(value: 'all', label: 'All SKUs'),
                      AdminSelectOption(value: 'low', label: 'Low stock only'),
                    ],
                    onChanged: (value) {
                      context.read<InventoryCubit>().lowStockOnlyChanged(
                        value == 'low',
                      );
                    },
                  ),
                ],
                columns: const [
                  AdminTableColumn(label: 'Product', flex: 2),
                  AdminTableColumn(label: 'Variant'),
                  AdminTableColumn(label: 'SKU'),
                  AdminTableColumn(label: 'Stock', flex: 1),
                  AdminTableColumn(label: 'Status'),
                  AdminTableColumn(label: 'Actions', flex: 1),
                ],
                rowCount: items.length,
                cells: (index) => _cells(context, items[index], threshold),
                emptyLabel: 'No matching stock rows',
                page: PageSlice.clampPage(state.page, filtered.length),
                total: filtered.length,
                onPageChanged: context.read<InventoryCubit>().pageChanged,
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _cells(
    BuildContext context,
    InventoryRow row,
    int threshold,
  ) {
    final low = row.stock <= threshold;
    return [
      AdminTextCell(row.productName, emphasis: true),
      AdminTextCell(row.variantName),
      AdminTextCell(row.sku),
      AdminTextCell('${row.stock}'),
      StatusChip(
        label: row.stock == 0
            ? 'Out of stock'
            : low
            ? 'Low'
            : 'In stock',
        tone: row.stock == 0
            ? AdminChipTone.danger
            : low
            ? AdminChipTone.pending
            : AdminChipTone.success,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () => _editStock(context, row),
          child: const Text('Edit'),
        ),
      ),
    ];
  }

  void _editStock(BuildContext context, InventoryRow row) {
    var value = '${row.stock}';
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Stock · ${row.sku}'),
          content: TextFormField(
            initialValue: value,
            keyboardType: TextInputType.number,
            onChanged: (text) => value = text,
            decoration: const InputDecoration(labelText: 'Units'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final stock = int.tryParse(value.trim());
                if (stock == null || stock < 0) return;
                context.read<ProductsCubit>().updateStock(
                  productId: row.productId,
                  variantId: row.variantId,
                  stock: stock,
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

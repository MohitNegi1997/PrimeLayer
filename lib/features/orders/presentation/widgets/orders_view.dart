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
import 'package:primelayer_admin_panel/core/widgets/confirm_delete_dialog.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_state.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_state.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/widgets/order_editor_dialog.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_state.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<OrdersCubit>().clearNotice();
      },
      child: BlocBuilder<CustomersCubit, CustomersState>(
        builder: (context, customersState) {
          return BlocBuilder<ShippingCubit, ShippingState>(
            builder: (context, shippingState) {
              return BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  final items = state.pagedOrders;
                  return AdminListScaffold(
                    title: 'Orders',
                    subtitle: 'Review store orders, print status, and fulfillment.',
                    actions: [
                      ElevatedButton.icon(
                        onPressed: () => OrderEditorDialog.open(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add order'),
                      ),
                    ],
                    stats: _stats(state),
                    filters: [
                      AdminSearchField(
                        hint: 'Search by order number',
                        onChanged: context.read<OrdersCubit>().searchChanged,
                      ),
                      AdminSelectField(
                        label: 'Status',
                        value: state.status?.name ?? 'all',
                        options: [
                          const AdminSelectOption(
                            value: 'all',
                            label: 'All statuses',
                          ),
                          for (final value in OrderStatus.values)
                            AdminSelectOption(
                              value: value.name,
                              label: value.label,
                            ),
                        ],
                        onChanged: (value) {
                          context.read<OrdersCubit>().statusChanged(
                            value == 'all'
                                ? null
                                : OrderStatus.values.firstWhere(
                                    (item) => item.name == value,
                                  ),
                          );
                        },
                      ),
                    ],
                    columns: const [
                      AdminTableColumn(label: 'Order'),
                      AdminTableColumn(label: 'Customer', flex: 2),
                      AdminTableColumn(label: 'Placed on', flex: 2),
                      AdminTableColumn(label: 'Shipping'),
                      AdminTableColumn(label: 'Items', flex: 1),
                      AdminTableColumn(label: 'Total'),
                      AdminTableColumn(label: 'Status'),
                      AdminTableColumn(label: 'Actions', flex: 1),
                    ],
                    rowCount: items.length,
                    cells: (index) => _cells(
                      context,
                      items[index],
                      customersState,
                      shippingState,
                    ),
                    onRowTap: (index) => OrderEditorDialog.open(
                      context,
                      order: items[index],
                    ),
                    emptyLabel: 'No matching orders',
                    page: state.safePage,
                    total: state.filteredOrders.length,
                    onPageChanged: context.read<OrdersCubit>().pageChanged,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  List<AdminStatMetric> _stats(OrdersState state) {
    var placed = 0;
    var printing = 0;
    var shipped = 0;
    for (final order in state.orders) {
      switch (order.status) {
        case OrderStatus.placed:
          placed += 1;
        case OrderStatus.printing:
          printing += 1;
        case OrderStatus.shipped:
          shipped += 1;
        default:
          break;
      }
    }
    return [
      AdminStatMetric(
        label: 'Total orders',
        value: '${state.orders.length}',
        caption: 'All time',
        icon: Icons.receipt_long_outlined,
      ),
      AdminStatMetric(
        label: 'New',
        value: '$placed',
        caption: 'Awaiting action',
        icon: Icons.schedule_outlined,
        tone: AdminChipTone.pending,
      ),
      AdminStatMetric(
        label: 'Printing',
        value: '$printing',
        caption: 'On the floor',
        icon: Icons.print_outlined,
        tone: AdminChipTone.info,
      ),
      AdminStatMetric(
        label: 'Shipped',
        value: '$shipped',
        caption: 'In transit',
        icon: Icons.local_shipping_outlined,
        tone: AdminChipTone.success,
      ),
    ];
  }

  List<Widget> _cells(
    BuildContext context,
    ShopOrder order,
    CustomersState customersState,
    ShippingState shippingState,
  ) {
    return [
      AdminTextCell(order.number, emphasis: true),
      AdminTextCell(customersState.nameFor(order.customerId)),
      AdminTextCell(DateLabel.of(order.placedAt)),
      AdminTextCell(shippingState.nameFor(order.shippingMethodId)),
      AdminTextCell('${order.itemCount}'),
      AdminTextCell(order.totalLabel),
      StatusChip(label: order.status.label, tone: _tone(order.status)),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              OrderEditorDialog.open(context, order: order);
            case 'delete':
              ConfirmDeleteDialog.open(
                context,
                title: 'Delete ${order.number}?',
                message: 'This cannot be undone.',
                onConfirm: () => context.read<OrdersCubit>().delete(order.id),
              );
          }
        },
        items: const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ];
  }

  AdminChipTone _tone(OrderStatus status) {
    return switch (status) {
      OrderStatus.placed => AdminChipTone.pending,
      OrderStatus.printing || OrderStatus.packed => AdminChipTone.info,
      OrderStatus.shipped || OrderStatus.delivered => AdminChipTone.success,
      OrderStatus.cancelled => AdminChipTone.danger,
    };
  }
}

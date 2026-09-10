import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/format/date_label.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_row_menu.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_search_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/confirm_delete_dialog.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_state.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/widgets/customer_editor_dialog.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_state.dart';

class CustomersView extends StatelessWidget {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomersCubit, CustomersState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<CustomersCubit>().clearNotice();
      },
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, ordersState) {
          return BlocBuilder<CustomersCubit, CustomersState>(
            builder: (context, state) {
              final items = state.pagedCustomers;
              var withOrders = 0;
              final cities = <String>{};
              for (final customer in state.customers) {
                cities.add(customer.city);
                if (ordersState.countForCustomer(customer.id) > 0) {
                  withOrders += 1;
                }
              }
              return AdminListScaffold(
                title: 'Customers',
                subtitle: 'Website buyers linked to orders and payments.',
                actions: [
                  ElevatedButton.icon(
                    onPressed: () => CustomerEditorDialog.open(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add customer'),
                  ),
                ],
                stats: [
                  AdminStatMetric(
                    label: 'Total customers',
                    value: '${state.customers.length}',
                    caption: 'In the store',
                    icon: Icons.people_outlined,
                  ),
                  AdminStatMetric(
                    label: 'With orders',
                    value: '$withOrders',
                    caption: 'Have purchased',
                    icon: Icons.shopping_bag_outlined,
                    tone: AdminChipTone.success,
                  ),
                  AdminStatMetric(
                    label: 'Cities',
                    value: '${cities.length}',
                    caption: 'Shipping cities',
                    icon: Icons.location_city_outlined,
                    tone: AdminChipTone.info,
                  ),
                  AdminStatMetric(
                    label: 'Showing',
                    value: '${state.filteredCustomers.length}',
                    caption: 'Match filters',
                    icon: Icons.filter_alt_outlined,
                    tone: AdminChipTone.pending,
                  ),
                ],
                filters: [
                  AdminSearchField(
                    hint: 'Search by name, email, or city',
                    onChanged: context.read<CustomersCubit>().searchChanged,
                  ),
                ],
                columns: const [
                  AdminTableColumn(label: 'Customer', flex: 2),
                  AdminTableColumn(label: 'Email', flex: 3),
                  AdminTableColumn(label: 'Phone'),
                  AdminTableColumn(label: 'City'),
                  AdminTableColumn(label: 'Joined', flex: 2),
                  AdminTableColumn(label: 'Orders', flex: 1),
                  AdminTableColumn(label: 'Actions', flex: 1),
                ],
                rowCount: items.length,
                cells: (index) => _cells(context, items[index], ordersState),
                onRowTap: (index) => CustomerEditorDialog.open(
                  context,
                  customer: items[index],
                ),
                emptyLabel: 'No matching customers',
                page: state.safePage,
                total: state.filteredCustomers.length,
                onPageChanged: context.read<CustomersCubit>().pageChanged,
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _cells(
    BuildContext context,
    Customer customer,
    OrdersState ordersState,
  ) {
    final orders = ordersState.countForCustomer(customer.id);
    return [
      AdminTextCell(customer.name, emphasis: true),
      AdminTextCell(customer.email),
      AdminTextCell(customer.phone),
      AdminTextCell(customer.city),
      AdminTextCell(DateLabel.of(customer.joinedAt)),
      AdminTextCell('$orders'),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              CustomerEditorDialog.open(context, customer: customer);
            case 'delete':
              ConfirmDeleteDialog.open(
                context,
                title: 'Delete ${customer.name}?',
                message: 'This cannot be undone.',
                onConfirm: () =>
                    context.read<CustomersCubit>().delete(customer.id),
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
}

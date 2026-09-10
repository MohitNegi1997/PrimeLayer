import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_cubit.dart';

class OrdersToolbar extends StatelessWidget {
  const OrdersToolbar({
    super.key,
    required this.status,
    required this.onAdd,
  });

  final OrderStatus? status;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final title = Text('Orders', style: theme.textTheme.titleLarge);
    final addButton = ElevatedButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add),
      label: const Text('Add order'),
    );
    final search = TextField(
      onChanged: context.read<OrdersCubit>().searchChanged,
      decoration: const InputDecoration(
        labelText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    );
    final selected = status?.name ?? 'all';
    final filter = DropdownButtonFormField<String>(
      key: ValueKey(selected),
      initialValue: selected,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Status'),
      items: [
        const DropdownMenuItem(value: 'all', child: Text('All statuses')),
        for (final value in OrderStatus.values)
          DropdownMenuItem(value: value.name, child: Text(value.label)),
      ],
      onChanged: (value) {
        context.read<OrdersCubit>().statusChanged(
          value == 'all'
              ? null
              : OrderStatus.values.firstWhere((item) => item.name == value),
        );
      },
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 12),
          addButton,
          const SizedBox(height: 12),
          search,
          const SizedBox(height: 12),
          filter,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: title),
            addButton,
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: search),
            const SizedBox(width: 16),
            SizedBox(width: 220, child: filter),
          ],
        ),
      ],
    );
  }
}

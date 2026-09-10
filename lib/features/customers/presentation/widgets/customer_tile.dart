import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';

class CustomerTile extends StatelessWidget {
  const CustomerTile({
    super.key,
    required this.customer,
    required this.orderCount,
    required this.onEdit,
    required this.onDelete,
  });

  final Customer customer;
  final int orderCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ordersLabel = orderCount == 1 ? '1 order' : '$orderCount orders';

    return ListTile(
      onTap: onEdit,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.tertiary.withValues(alpha: 0.35),
        foregroundColor: theme.colorScheme.primary,
        child: Text(
          customer.name.isEmpty ? '?' : customer.name[0].toUpperCase(),
        ),
      ),
      title: Text(customer.name, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${customer.email} · ${customer.city} · $ordersLabel',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              onEdit();
            case 'delete':
              onDelete();
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}

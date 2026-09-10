import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.customerName,
    required this.shippingName,
    required this.onEdit,
    required this.onDelete,
  });

  final ShopOrder order;
  final String customerName;
  final String shippingName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onEdit,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.tertiary.withValues(alpha: 0.35),
        foregroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.receipt_long_outlined),
      ),
      title: Text(
        '${order.number} · ${order.totalLabel}',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$customerName · ${order.status.label} · $shippingName · ${order.itemCount} items',
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

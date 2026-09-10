import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/media_thumb.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.categoryName,
    required this.onEdit,
    required this.onToggleVisibility,
    required this.onDelete,
  });

  final Product product;
  final String categoryName;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggleVisibility;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return ListTile(
      onTap: onEdit,
      leading: MediaThumb(
        url: product.imageUrl,
        bytes: product.imageBytes,
        icon: Icons.inventory_2_outlined,
      ),
      title: Text(product.name, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '/${product.slug} · $categoryName · ${product.variantLabel} · ${product.priceLabel} · ${product.totalStock} stock',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMobile)
            Switch(value: product.isVisible, onChanged: onToggleVisibility),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit();
                case 'visibility':
                  onToggleVisibility(!product.isVisible);
                case 'delete':
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'visibility',
                child: Text(product.isVisible ? 'Hide' : 'Show'),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}

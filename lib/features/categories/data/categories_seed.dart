import 'package:primelayer_admin_panel/features/categories/domain/catalog_product.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_icons.dart';

abstract final class CategoriesSeed {
  static const List<CatalogProduct> products = [
    CatalogProduct(id: 'dragon', name: 'Dragon'),
    CatalogProduct(id: 'stand', name: 'Stand'),
    CatalogProduct(id: 'keycap', name: 'Keycap'),
    CatalogProduct(id: 'planter', name: 'Planter'),
    CatalogProduct(id: 'chess', name: 'Chess'),
  ];

  static const List<Category> categories = [
    Category(
      id: 'figurines',
      name: 'Figurines',
      slug: 'figurines',
      description: 'Printed figures and collectibles',
      iconKey: CategoryIcons.figurine,
      isVisible: true,
      sortOrder: 0,
      productIds: ['dragon'],
    ),
    Category(
      id: 'desk',
      name: 'Desk',
      slug: 'desk',
      description: 'Stands, keycaps, and desk tools',
      iconKey: CategoryIcons.desk,
      isVisible: true,
      sortOrder: 1,
      productIds: ['stand', 'keycap'],
    ),
    Category(
      id: 'home',
      name: 'Home',
      slug: 'home',
      description: 'Planters and home decor',
      iconKey: CategoryIcons.plant,
      isVisible: true,
      sortOrder: 2,
      productIds: ['planter'],
    ),
    Category(
      id: 'games',
      name: 'Games',
      slug: 'games',
      description: 'Board games and game pieces',
      iconKey: CategoryIcons.game,
      isVisible: true,
      sortOrder: 3,
      productIds: ['chess'],
    ),
    Category(
      id: 'seasonal',
      name: 'Seasonal',
      slug: 'seasonal',
      description: 'Limited drops and holiday prints',
      iconKey: CategoryIcons.star,
      isVisible: false,
      sortOrder: 4,
      productIds: [],
    ),
  ];
}

import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_icons.dart';

abstract final class CategoriesSeed {
  static const List<Category> categories = [
    Category(
      id: 'figurines',
      name: 'Figurines',
      slug: 'figurines',
      description: 'Printed figures and collectibles',
      iconKey: CategoryIcons.figurine,
      isVisible: true,
      sortOrder: 0,
    ),
    Category(
      id: 'desk',
      name: 'Desk',
      slug: 'desk',
      description: 'Stands, keycaps, and desk tools',
      iconKey: CategoryIcons.desk,
      isVisible: true,
      sortOrder: 1,
    ),
    Category(
      id: 'home',
      name: 'Home',
      slug: 'home',
      description: 'Planters and home decor',
      iconKey: CategoryIcons.plant,
      isVisible: true,
      sortOrder: 2,
    ),
    Category(
      id: 'games',
      name: 'Games',
      slug: 'games',
      description: 'Board games and game pieces',
      iconKey: CategoryIcons.game,
      isVisible: true,
      sortOrder: 3,
    ),
    Category(
      id: 'seasonal',
      name: 'Seasonal',
      slug: 'seasonal',
      description: 'Limited drops and holiday prints',
      iconKey: CategoryIcons.star,
      isVisible: false,
      sortOrder: 4,
    ),
  ];
}

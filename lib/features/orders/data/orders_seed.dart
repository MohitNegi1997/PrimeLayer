import 'package:primelayer_admin_panel/features/orders/data/orders_seed_factory.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_item.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';

abstract final class OrdersSeed {
  static final List<ShopOrder> orders = [
    OrdersSeedFactory.create(
      id: 'o-1001',
      customerId: 'c-01',
      status: OrderStatus.shipped,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 8, 28, 11),
      items: const [
        OrderItem(
          productId: 'dragon',
          variantId: 'dragon-15',
          name: 'Dragon 15cm',
          sku: 'DRG-15',
          quantity: 1,
          price: 899,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1002',
      customerId: 'c-02',
      status: OrderStatus.printing,
      shippingMethodId: 'ship-exp',
      placedAt: DateTime(2026, 9, 2, 14),
      items: const [
        OrderItem(
          productId: 'stand',
          variantId: 'stand-std',
          name: 'Stand Standard',
          sku: 'STN-STD',
          quantity: 2,
          price: 499,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1003',
      customerId: 'c-03',
      status: OrderStatus.placed,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 9, 4, 9),
      items: const [
        OrderItem(
          productId: 'keycap',
          variantId: 'keycap-red',
          name: 'Keycap Red',
          sku: 'KEY-RED',
          quantity: 3,
          price: 199,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1004',
      customerId: 'c-04',
      status: OrderStatus.packed,
      shippingMethodId: 'ship-pickup',
      placedAt: DateTime(2026, 9, 5, 16),
      items: const [
        OrderItem(
          productId: 'planter',
          variantId: 'planter-s',
          name: 'Planter Small',
          sku: 'PLN-S',
          quantity: 1,
          price: 349,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1005',
      customerId: 'c-05',
      status: OrderStatus.delivered,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 8, 20, 12),
      items: const [
        OrderItem(
          productId: 'chess',
          variantId: 'chess-std',
          name: 'Chess Standard',
          sku: 'CHS-STD',
          quantity: 1,
          price: 2499,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1006',
      customerId: 'c-06',
      status: OrderStatus.cancelled,
      shippingMethodId: 'ship-exp',
      placedAt: DateTime(2026, 9, 1, 18),
      items: const [
        OrderItem(
          productId: 'fox',
          variantId: 'fox-org',
          name: 'Fox Orange',
          sku: 'FOX-ORG',
          quantity: 1,
          price: 749,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1007',
      customerId: 'c-07',
      status: OrderStatus.printing,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 9, 6, 10),
      items: const [
        OrderItem(
          productId: 'gecko',
          variantId: 'gecko-grn',
          name: 'Gecko Green',
          sku: 'GCK-GRN',
          quantity: 2,
          price: 599,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1008',
      customerId: 'c-03',
      status: OrderStatus.placed,
      shippingMethodId: 'ship-exp',
      placedAt: DateTime(2026, 9, 8, 15),
      items: const [
        OrderItem(
          productId: 'vase',
          variantId: 'vase-wht',
          name: 'Vase White',
          sku: 'VAS-WHT',
          quantity: 1,
          price: 899,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1009',
      customerId: 'c-08',
      status: OrderStatus.shipped,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 8, 30, 13),
      items: const [
        OrderItem(
          productId: 'hook',
          variantId: 'hook-blk',
          name: 'Hook Black',
          sku: 'HOK-BLK',
          quantity: 4,
          price: 229,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1010',
      customerId: 'c-09',
      status: OrderStatus.packed,
      shippingMethodId: 'ship-exp',
      placedAt: DateTime(2026, 9, 7, 11),
      items: const [
        OrderItem(
          productId: 'dice',
          variantId: 'dice-nvy',
          name: 'Dice Navy',
          sku: 'DIC-NVY',
          quantity: 1,
          price: 649,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1011',
      customerId: 'c-10',
      status: OrderStatus.placed,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 9, 9, 8),
      items: const [
        OrderItem(
          productId: 'bookmark',
          variantId: 'bookmark-std',
          name: 'Bookmark Standard',
          sku: 'BMK-STD',
          quantity: 5,
          price: 149,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1012',
      customerId: 'c-11',
      status: OrderStatus.printing,
      shippingMethodId: 'ship-pickup',
      placedAt: DateTime(2026, 9, 9, 19),
      items: const [
        OrderItem(
          productId: 'dragon',
          variantId: 'dragon-20',
          name: 'Dragon 20cm / Black',
          sku: 'DRG-20-BLK',
          quantity: 1,
          price: 1299,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1013',
      customerId: 'c-12',
      status: OrderStatus.delivered,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 8, 18, 17),
      items: const [
        OrderItem(
          productId: 'coaster',
          variantId: 'coaster-set',
          name: 'Coaster Set of 4',
          sku: 'CST-4',
          quantity: 2,
          price: 399,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1014',
      customerId: 'c-04',
      status: OrderStatus.shipped,
      shippingMethodId: 'ship-exp',
      placedAt: DateTime(2026, 9, 3, 12),
      items: const [
        OrderItem(
          productId: 'stand',
          variantId: 'stand-std',
          name: 'Stand Standard',
          sku: 'STN-STD',
          quantity: 1,
          price: 499,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1015',
      customerId: 'c-05',
      status: OrderStatus.placed,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 9, 10, 9),
      items: const [
        OrderItem(
          productId: 'planter',
          variantId: 'planter-s',
          name: 'Planter Small',
          sku: 'PLN-S',
          quantity: 2,
          price: 349,
        ),
      ],
    ),
    OrdersSeedFactory.create(
      id: 'o-1016',
      customerId: 'c-02',
      status: OrderStatus.packed,
      shippingMethodId: 'ship-std',
      placedAt: DateTime(2026, 9, 8, 20),
      items: const [
        OrderItem(
          productId: 'keycap',
          variantId: 'keycap-red',
          name: 'Keycap Red',
          sku: 'KEY-RED',
          quantity: 2,
          price: 199,
        ),
        OrderItem(
          productId: 'bookmark',
          variantId: 'bookmark-std',
          name: 'Bookmark Standard',
          sku: 'BMK-STD',
          quantity: 1,
          price: 149,
        ),
      ],
    ),
  ];
}

import 'package:primelayer_admin_panel/features/orders/domain/order_item.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';

abstract final class OrdersSeedFactory {
  static ShopOrder create({
    required String id,
    required String customerId,
    required OrderStatus status,
    required String shippingMethodId,
    required DateTime placedAt,
    required List<OrderItem> items,
  }) {
    return ShopOrder(
      id: id,
      number: 'PL-${id.split('-').last}',
      customerId: customerId,
      items: items,
      status: status,
      shippingMethodId: shippingMethodId,
      placedAt: placedAt,
    );
  }
}

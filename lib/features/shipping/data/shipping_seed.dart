import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';

abstract final class ShippingSeed {
  static const List<ShippingMethod> methods = [
    ShippingMethod(
      id: 'ship-std',
      name: 'Standard',
      eta: '5–7 days',
      price: 79,
      isActive: true,
    ),
    ShippingMethod(
      id: 'ship-exp',
      name: 'Express',
      eta: '2–3 days',
      price: 149,
      isActive: true,
    ),
    ShippingMethod(
      id: 'ship-pickup',
      name: 'Studio pickup',
      eta: 'Same day',
      price: 0,
      isActive: true,
    ),
  ];
}

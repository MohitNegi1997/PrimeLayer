import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  const OrderItem({
    required this.productId,
    required this.variantId,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.price,
  });

  final String productId;
  final String variantId;
  final String name;
  final String sku;
  final int quantity;
  final double price;

  double get lineTotal => price * quantity;

  @override
  List<Object?> get props => [productId, variantId, name, sku, quantity, price];
}

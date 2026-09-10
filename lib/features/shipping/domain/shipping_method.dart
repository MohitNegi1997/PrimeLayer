import 'package:equatable/equatable.dart';

class ShippingMethod extends Equatable {
  const ShippingMethod({
    required this.id,
    required this.name,
    required this.eta,
    required this.price,
    required this.isActive,
  });

  final String id;
  final String name;
  final String eta;
  final double price;
  final bool isActive;

  String get priceLabel => price == 0 ? 'Free' : '₹${price.toStringAsFixed(0)}';

  ShippingMethod copyWith({
    String? id,
    String? name,
    String? eta,
    double? price,
    bool? isActive,
  }) {
    return ShippingMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      eta: eta ?? this.eta,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, eta, price, isActive];
}

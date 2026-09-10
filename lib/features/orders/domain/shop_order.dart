import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_item.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';

class ShopOrder extends Equatable {
  const ShopOrder({
    required this.id,
    required this.number,
    required this.customerId,
    required this.items,
    required this.status,
    required this.shippingMethodId,
    required this.placedAt,
    this.notes = '',
  });

  final String id;
  final String number;
  final String customerId;
  final List<OrderItem> items;
  final OrderStatus status;
  final String shippingMethodId;
  final DateTime placedAt;
  final String notes;

  double get subtotal {
    var sum = 0.0;
    for (final item in items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  String get totalLabel => '₹${subtotal.toStringAsFixed(0)}';

  int get itemCount {
    var count = 0;
    for (final item in items) {
      count += item.quantity;
    }
    return count;
  }

  ShopOrder copyWith({
    String? id,
    String? number,
    String? customerId,
    List<OrderItem>? items,
    OrderStatus? status,
    String? shippingMethodId,
    DateTime? placedAt,
    String? notes,
  }) {
    return ShopOrder(
      id: id ?? this.id,
      number: number ?? this.number,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      status: status ?? this.status,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      placedAt: placedAt ?? this.placedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    number,
    customerId,
    items,
    status,
    shippingMethodId,
    placedAt,
    notes,
  ];
}

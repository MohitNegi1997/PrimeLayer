import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_item.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';

enum OrderFormStatus { initial, success }

class OrderFormState extends Equatable {
  const OrderFormState({
    this.id,
    this.number = '',
    this.customerId = '',
    this.productId = '',
    this.variantId = '',
    this.quantity = '1',
    this.shippingMethodId = '',
    this.status = OrderStatus.placed,
    this.notes = '',
    this.placedAt,
    this.existingItems = const [],
    this.formStatus = OrderFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String number;
  final String customerId;
  final String productId;
  final String variantId;
  final String quantity;
  final String shippingMethodId;
  final OrderStatus status;
  final String notes;
  final DateTime? placedAt;
  final List<OrderItem> existingItems;
  final OrderFormStatus formStatus;
  final String? errorMessage;

  bool get isEditing => id != null;

  ShopOrder toOrder(List<Product> products) {
    final items = isEditing ? existingItems : [_itemFromSelection(products)];
    final stamp = placedAt ?? DateTime.now();
    final generatedId = id ?? 'o-${stamp.microsecondsSinceEpoch}';
    return ShopOrder(
      id: generatedId,
      number: number.trim().isEmpty
          ? 'PL-${stamp.millisecondsSinceEpoch % 10000}'
          : number.trim(),
      customerId: customerId,
      items: items,
      status: status,
      shippingMethodId: shippingMethodId,
      placedAt: stamp,
      notes: notes.trim(),
    );
  }

  OrderItem _itemFromSelection(List<Product> products) {
    for (final product in products) {
      if (product.id != productId) continue;
      for (final variant in product.variants) {
        if (variant.id != variantId) continue;
        return OrderItem(
          productId: product.id,
          variantId: variant.id,
          name: '${product.name} ${variant.name}',
          sku: variant.sku,
          quantity: int.parse(quantity.trim()),
          price: variant.price,
        );
      }
    }
    throw StateError('Missing product variant');
  }

  OrderFormState copyWith({
    String? id,
    String? number,
    String? customerId,
    String? productId,
    String? variantId,
    String? quantity,
    String? shippingMethodId,
    OrderStatus? status,
    String? notes,
    DateTime? placedAt,
    List<OrderItem>? existingItems,
    OrderFormStatus? formStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrderFormState(
      id: id ?? this.id,
      number: number ?? this.number,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      placedAt: placedAt ?? this.placedAt,
      existingItems: existingItems ?? this.existingItems,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    number,
    customerId,
    productId,
    variantId,
    quantity,
    shippingMethodId,
    status,
    notes,
    placedAt,
    existingItems,
    formStatus,
    errorMessage,
  ];
}

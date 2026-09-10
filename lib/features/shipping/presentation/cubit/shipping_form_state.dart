import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';

enum ShippingFormStatus { initial, success }

class ShippingFormState extends Equatable {
  const ShippingFormState({
    this.id,
    this.name = '',
    this.eta = '',
    this.price = '',
    this.isActive = true,
    this.status = ShippingFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String name;
  final String eta;
  final String price;
  final bool isActive;
  final ShippingFormStatus status;
  final String? errorMessage;

  bool get isEditing => id != null;

  ShippingMethod toMethod() {
    return ShippingMethod(
      id: id ?? 'ship-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      eta: eta.trim(),
      price: double.parse(price.trim()),
      isActive: isActive,
    );
  }

  ShippingFormState copyWith({
    String? id,
    String? name,
    String? eta,
    String? price,
    bool? isActive,
    ShippingFormStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ShippingFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      eta: eta ?? this.eta,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    eta,
    price,
    isActive,
    status,
    errorMessage,
  ];
}

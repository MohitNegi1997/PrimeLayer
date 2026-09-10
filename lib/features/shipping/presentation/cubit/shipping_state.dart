import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';

class ShippingState extends Equatable {
  const ShippingState({required this.methods, this.notice});

  final List<ShippingMethod> methods;
  final String? notice;

  ShippingMethod? byId(String id) {
    for (final method in methods) {
      if (method.id == id) return method;
    }
    return null;
  }

  String nameFor(String id) => byId(id)?.name ?? 'Unknown method';

  ShippingState copyWith({
    List<ShippingMethod>? methods,
    String? notice,
    bool clearNotice = false,
  }) {
    return ShippingState(
      methods: methods ?? this.methods,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [methods, notice];
}

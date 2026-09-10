import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_form_state.dart';

class ShippingFormCubit extends Cubit<ShippingFormState> {
  ShippingFormCubit({ShippingMethod? method})
    : super(
        method == null
            ? const ShippingFormState()
            : ShippingFormState(
                id: method.id,
                name: method.name,
                eta: method.eta,
                price: method.price.toStringAsFixed(0),
                isActive: method.isActive,
              ),
      );

  void nameChanged(String name) {
    emit(
      state.copyWith(
        name: name,
        status: ShippingFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void etaChanged(String eta) {
    emit(
      state.copyWith(
        eta: eta,
        status: ShippingFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void priceChanged(String price) {
    emit(
      state.copyWith(
        price: price,
        status: ShippingFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void activeChanged(bool isActive) {
    emit(
      state.copyWith(
        isActive: isActive,
        status: ShippingFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a name'));
      return;
    }
    if (state.eta.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter an ETA'));
      return;
    }
    final price = double.tryParse(state.price.trim());
    if (price == null || price < 0) {
      emit(state.copyWith(errorMessage: 'Enter a valid price'));
      return;
    }
    emit(state.copyWith(status: ShippingFormStatus.success, clearError: true));
  }
}

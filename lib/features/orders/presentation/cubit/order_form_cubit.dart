import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/order_form_state.dart';

class OrderFormCubit extends Cubit<OrderFormState> {
  OrderFormCubit({
    ShopOrder? order,
    required String defaultCustomerId,
    required String defaultProductId,
    required String defaultVariantId,
    required String defaultShippingId,
  }) : super(
         order == null
             ? OrderFormState(
                 customerId: defaultCustomerId,
                 productId: defaultProductId,
                 variantId: defaultVariantId,
                 shippingMethodId: defaultShippingId,
               )
             : OrderFormState(
                 id: order.id,
                 number: order.number,
                 customerId: order.customerId,
                 shippingMethodId: order.shippingMethodId,
                 status: order.status,
                 notes: order.notes,
                 placedAt: order.placedAt,
                 existingItems: order.items,
                 productId: defaultProductId,
                 variantId: defaultVariantId,
               ),
       );

  void customerChanged(String customerId) {
    emit(
      state.copyWith(
        customerId: customerId,
        formStatus: OrderFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void productChanged(String productId, String variantId) {
    emit(
      state.copyWith(
        productId: productId,
        variantId: variantId,
        formStatus: OrderFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void quantityChanged(String quantity) {
    emit(
      state.copyWith(
        quantity: quantity,
        formStatus: OrderFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void shippingChanged(String shippingMethodId) {
    emit(
      state.copyWith(
        shippingMethodId: shippingMethodId,
        formStatus: OrderFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void statusChanged(OrderStatus status) {
    emit(
      state.copyWith(
        status: status,
        formStatus: OrderFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void notesChanged(String notes) {
    emit(
      state.copyWith(
        notes: notes,
        formStatus: OrderFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    if (state.customerId.isEmpty) {
      emit(state.copyWith(errorMessage: 'Select a customer'));
      return;
    }
    if (state.shippingMethodId.isEmpty) {
      emit(state.copyWith(errorMessage: 'Select shipping'));
      return;
    }
    if (!state.isEditing) {
      if (state.productId.isEmpty || state.variantId.isEmpty) {
        emit(state.copyWith(errorMessage: 'Select a product'));
        return;
      }
      final qty = int.tryParse(state.quantity.trim());
      if (qty == null || qty < 1) {
        emit(state.copyWith(errorMessage: 'Enter a quantity'));
        return;
      }
    }
    emit(
      state.copyWith(formStatus: OrderFormStatus.success, clearError: true),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customer_form_state.dart';

class CustomerFormCubit extends Cubit<CustomerFormState> {
  CustomerFormCubit({Customer? customer})
    : super(
        customer == null
            ? const CustomerFormState()
            : CustomerFormState(
                id: customer.id,
                name: customer.name,
                email: customer.email,
                phone: customer.phone,
                city: customer.city,
                joinedAt: customer.joinedAt,
              ),
      );

  void nameChanged(String name) {
    emit(
      state.copyWith(
        name: name,
        status: CustomerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void emailChanged(String email) {
    emit(
      state.copyWith(
        email: email,
        status: CustomerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void phoneChanged(String phone) {
    emit(
      state.copyWith(
        phone: phone,
        status: CustomerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void cityChanged(String city) {
    emit(
      state.copyWith(
        city: city,
        status: CustomerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a name'));
      return;
    }
    if (state.email.trim().isEmpty || !state.email.contains('@')) {
      emit(state.copyWith(errorMessage: 'Enter a valid email'));
      return;
    }
    if (state.phone.trim().length < 10) {
      emit(state.copyWith(errorMessage: 'Enter a valid phone'));
      return;
    }
    if (state.city.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a city'));
      return;
    }
    emit(state.copyWith(status: CustomerFormStatus.success, clearError: true));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_user.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/staff_form_state.dart';

class StaffFormCubit extends Cubit<StaffFormState> {
  StaffFormCubit({StaffUser? user})
    : super(
        user == null
            ? const StaffFormState()
            : StaffFormState(
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
                isActive: user.isActive,
              ),
      );

  void nameChanged(String name) {
    emit(
      state.copyWith(
        name: name,
        status: StaffFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void emailChanged(String email) {
    emit(
      state.copyWith(
        email: email,
        status: StaffFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void roleChanged(StaffRole role) {
    emit(
      state.copyWith(
        role: role,
        status: StaffFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void activeChanged(bool isActive) {
    emit(
      state.copyWith(
        isActive: isActive,
        status: StaffFormStatus.initial,
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
    emit(state.copyWith(status: StaffFormStatus.success, clearError: true));
  }
}

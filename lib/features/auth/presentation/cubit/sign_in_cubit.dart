import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/features/auth/data/admin_credentials.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authCubit) : super(const SignInState());

  final AuthCubit _authCubit;

  void emailChanged(String email) {
    emit(
      state.copyWith(
        email: email,
        status: SignInStatus.initial,
        clearError: true,
      ),
    );
  }

  void passwordChanged(String password) {
    emit(
      state.copyWith(
        password: password,
        status: SignInStatus.initial,
        clearError: true,
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  Future<void> signIn() async {
    if (state.status == SignInStatus.submitting) return;

    final email = state.email.trim();
    final password = state.password;

    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: 'Enter email and password',
        ),
      );
      return;
    }

    if (AdminCredentials.matches(email: email, password: password)) {
      emit(state.copyWith(status: SignInStatus.submitting, clearError: true));
      await Future<void>.delayed(AppConstants.signInLoaderDuration);
      if (isClosed) return;
      await _authCubit.persistSession();
      if (isClosed) return;
      emit(state.copyWith(status: SignInStatus.success, clearError: true));
      return;
    }

    emit(
      state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Invalid email or password',
      ),
    );
  }
}

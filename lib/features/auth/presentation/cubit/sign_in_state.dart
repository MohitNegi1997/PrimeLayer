import 'package:equatable/equatable.dart';

enum SignInStatus { initial, success, failure }

class SignInState extends Equatable {
  const SignInState({
    this.email = '',
    this.password = '',
    this.isPasswordObscured = true,
    this.status = SignInStatus.initial,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool isPasswordObscured;
  final SignInStatus status;
  final String? errorMessage;

  SignInState copyWith({
    String? email,
    String? password,
    bool? isPasswordObscured,
    SignInStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isPasswordObscured,
    status,
    errorMessage,
  ];
}

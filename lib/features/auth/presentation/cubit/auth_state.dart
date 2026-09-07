import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState({required this.isSignedIn});

  const AuthState.signedOut() : isSignedIn = false;

  const AuthState.signedIn() : isSignedIn = true;

  final bool isSignedIn;

  @override
  List<Object> get props => [isSignedIn];
}

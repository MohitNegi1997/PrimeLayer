import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/auth/data/auth_session_store.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._store) : super(const AuthState.signedOut());

  final AuthSessionStore _store;

  void restore() {
    _emitFromStore();
  }

  void revalidate() {
    _emitFromStore();
  }

  Future<void> persistSession() async {
    await _store.save();
    emit(const AuthState.signedIn());
  }

  Future<void> signOut() async {
    await _store.clear();
    emit(const AuthState.signedOut());
  }

  void _emitFromStore() {
    final isValid = _store.isValid;
    if (!isValid) {
      _store.clear();
    }
    final next = isValid
        ? const AuthState.signedIn()
        : const AuthState.signedOut();
    if (next != state) {
      emit(next);
    }
  }
}

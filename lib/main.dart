import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/app.dart';
import 'package:primelayer_admin_panel/core/router/app_router.dart';
import 'package:primelayer_admin_panel/features/auth/data/auth_session_store.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authCubit = AuthCubit(AuthSessionStore(prefs))..restore();
  runApp(
    PrimeLayerAdminApp(
      authCubit: authCubit,
      router: AppRouter.create(authCubit),
    ),
  );
}

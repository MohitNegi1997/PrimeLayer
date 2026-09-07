import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:primelayer_admin_panel/app.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/router/app_router.dart';
import 'package:primelayer_admin_panel/core/widgets/app_loader.dart';
import 'package:primelayer_admin_panel/features/auth/data/admin_credentials.dart';
import 'package:primelayer_admin_panel/features/auth/data/auth_session_store.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/profile_menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows printer loader on splash', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final authCubit = AuthCubit(AuthSessionStore(prefs))..restore();
    await tester.pumpWidget(
      PrimeLayerAdminApp(
        authCubit: authCubit,
        router: AppRouter.create(authCubit),
      ),
    );
    await tester.pump();

    expect(find.byType(AppLoader), findsOneWidget);
    expect(find.text(AppConstants.studioName), findsWidgets);
  });

  testWidgets('renders sign in', (tester) async {
    await _pumpApp(tester);

    expect(find.byType(AppLoader), findsNothing);
    expect(find.text(AppConstants.studioName), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('signs in with valid credentials', (tester) async {
    await _pumpApp(tester);

    await tester.enterText(
      find.byType(TextField).at(0),
      'mohitnegi699@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(1), '123456789');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pump();
    expect(find.byType(AppLoader), findsOneWidget);
    await tester.pump(AppConstants.signInLoaderDuration);
    await tester.pump();
    await tester.pump();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('3D PRINTED ORIGINALS'), findsOneWidget);
    expect(find.text(AdminCredentials.displayName), findsOneWidget);
    expect(find.text(AdminCredentials.email), findsWidgets);
  });

  testWidgets('back does not return to sign in while signed in', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      AuthSessionStore.signedInAtKey: DateTime.now().millisecondsSinceEpoch,
    });
    await _pumpApp(tester);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('3D PRINTED ORIGINALS'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsNothing);
  });

  testWidgets('profile menu opens settings and logout', (tester) async {
    SharedPreferences.setMockInitialValues({
      AuthSessionStore.signedInAtKey: DateTime.now().millisecondsSinceEpoch,
    });
    await _pumpApp(tester);

    await tester.tap(find.byType(ProfileMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile Setting'));
    await tester.pumpAndSettle();

    expect(find.text('Profile Setting'), findsWidgets);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ProfileMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('skips sign in when session is valid', (tester) async {
    SharedPreferences.setMockInitialValues({
      AuthSessionStore.signedInAtKey: DateTime.now().millisecondsSinceEpoch,
    });
    await _pumpApp(tester);

    expect(find.text('3D PRINTED ORIGINALS'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsNothing);
  });

  testWidgets('shows sign in when session is expired', (tester) async {
    SharedPreferences.setMockInitialValues({
      AuthSessionStore.signedInAtKey: DateTime.now()
          .subtract(const Duration(hours: 25))
          .millisecondsSinceEpoch,
    });
    await _pumpApp(tester);

    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
    expect(find.text('3D PRINTED ORIGINALS'), findsNothing);
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  final prefs = await SharedPreferences.getInstance();
  final authCubit = AuthCubit(AuthSessionStore(prefs))..restore();
  await tester.pumpWidget(
    PrimeLayerAdminApp(
      authCubit: authCubit,
      router: AppRouter.create(authCubit),
    ),
  );
  await tester.pump();
  await tester.pump(AppConstants.splashDuration);
  await tester.pump();
}

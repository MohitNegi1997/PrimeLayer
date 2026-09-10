import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:primelayer_admin_panel/app.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/router/app_router.dart';
import 'package:primelayer_admin_panel/features/auth/data/auth_session_store.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({
      AuthSessionStore.signedInAtKey: DateTime.now().millisecondsSinceEpoch,
    });
  });

  testWidgets('shows website carousel banners', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpApp(tester);

    await tester.tap(find.text('Website').first);
    await tester.pumpAndSettle();

    expect(find.text('Print your world'), findsWidgets);
    expect(find.widgetWithText(ElevatedButton, 'Add banner'), findsOneWidget);
    expect(find.textContaining('Website carousel'), findsOneWidget);
  });

  testWidgets('shows mapped orders', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpApp(tester);

    await tester.tap(find.text('Order Management').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('PL-1001'), findsOneWidget);
    expect(find.textContaining('Aarav Shah'), findsOneWidget);
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

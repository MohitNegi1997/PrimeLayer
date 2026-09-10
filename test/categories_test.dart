import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:primelayer_admin_panel/app.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/router/app_router.dart';
import 'package:primelayer_admin_panel/features/auth/data/auth_session_store.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
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

  test('blocks delete when products are assigned', () {
    final cubit = CategoriesCubit();
    cubit.delete('figurines', productCount: 1);
    expect(
      cubit.state.notice,
      'Move products out of Figurines before deleting it',
    );
    expect(
      cubit.state.categories.any((item) => item.id == 'figurines'),
      isTrue,
    );
  });

  testWidgets('shows seeded categories', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpApp(tester);

    await tester.tap(find.text('Categories').first);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Add category'), findsOneWidget);
    expect(find.text('Figurines'), findsOneWidget);
    expect(find.text('Desk'), findsOneWidget);
    expect(find.text('Seasonal'), findsOneWidget);
  });

  testWidgets('adds a category', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpApp(tester);

    await tester.tap(find.text('Categories').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add category'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Miniatures');
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Miniatures'), findsOneWidget);
    expect(find.text('Miniatures saved'), findsOneWidget);
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

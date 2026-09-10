import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:primelayer_admin_panel/app.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/router/app_router.dart';
import 'package:primelayer_admin_panel/features/auth/data/auth_session_store.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
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

  test('saves and deletes products', () {
    final cubit = ProductsCubit();
    cubit.save(
      const Product(
        id: 'lamp',
        name: 'Lamp',
        slug: 'lamp',
        description: 'Desk lamp',
        categoryId: 'desk',
        isVisible: true,
        variants: [],
      ),
    );
    expect(cubit.state.notice, 'Lamp saved');
    expect(cubit.state.products.any((item) => item.id == 'lamp'), isTrue);

    cubit.delete('lamp');
    expect(cubit.state.notice, 'Lamp deleted');
    expect(cubit.state.products.any((item) => item.id == 'lamp'), isFalse);
  });

  test('adds a variant on an existing product form', () {
    final cubit = ProductFormCubit(
      product: const Product(
        id: 'keycap',
        name: 'Keycap',
        slug: 'keycap',
        description: 'Custom artisan keycap',
        categoryId: 'desk',
        isVisible: true,
        variants: [],
      ),
      existingSlugs: const [],
      defaultCategoryId: 'desk',
    );
    cubit.saveVariant(
      const ProductVariant(
        id: 'keycap-red',
        name: 'Red',
        sku: 'KEY-RED',
        price: 199,
        color: 'Red',
      ),
    );
    expect(cubit.state.variants, hasLength(1));
    expect(cubit.state.variants.first.sku, 'KEY-RED');
  });

  testWidgets('shows seeded products', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpApp(tester);

    await tester.tap(find.text('Product Management').first);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Add product'), findsOneWidget);
    expect(find.text('Dragon'), findsOneWidget);
    expect(find.text('Stand'), findsOneWidget);
    expect(find.text('Keycap'), findsOneWidget);
  });

  testWidgets('adds a product', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpApp(tester);

    await tester.tap(find.text('Product Management').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add product'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Lamp');
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Lamp'), findsOneWidget);
    expect(find.text('Lamp saved'), findsOneWidget);
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

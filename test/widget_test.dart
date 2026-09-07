import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:primelayer_admin_panel/app.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('renders dashboard', (tester) async {
    await tester.pumpWidget(const PrimeLayerAdminApp());
    await tester.pump();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('3D PRINTED ORIGINALS'), findsOneWidget);
  });
}

import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/features/settings/domain/store_settings.dart';

abstract final class SettingsSeed {
  static const StoreSettings settings = StoreSettings(
    storeName: AppConstants.studioName,
    supportEmail: 'hello@primelayer.studio',
    supportPhone: '9876500999',
    gstin: '08AABCU9603R1ZM',
    currency: 'INR',
    lowStockThreshold: 5,
    orderPrefix: 'PL',
  );
}

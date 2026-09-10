import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/settings/data/settings_seed.dart';
import 'package:primelayer_admin_panel/features/settings/domain/store_settings.dart';
import 'package:primelayer_admin_panel/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(SettingsState.fromSettings(SettingsSeed.settings));

  void storeNameChanged(String value) {
    emit(state.copyWith(storeName: value, clearNotice: true, clearError: true));
  }

  void supportEmailChanged(String value) {
    emit(
      state.copyWith(supportEmail: value, clearNotice: true, clearError: true),
    );
  }

  void supportPhoneChanged(String value) {
    emit(
      state.copyWith(supportPhone: value, clearNotice: true, clearError: true),
    );
  }

  void gstinChanged(String value) {
    emit(state.copyWith(gstin: value, clearNotice: true, clearError: true));
  }

  void currencyChanged(String value) {
    emit(state.copyWith(currency: value, clearNotice: true, clearError: true));
  }

  void lowStockChanged(String value) {
    emit(
      state.copyWith(
        lowStockThreshold: value,
        clearNotice: true,
        clearError: true,
      ),
    );
  }

  void orderPrefixChanged(String value) {
    emit(
      state.copyWith(orderPrefix: value, clearNotice: true, clearError: true),
    );
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void save() {
    if (state.storeName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a store name'));
      return;
    }
    final threshold = int.tryParse(state.lowStockThreshold.trim());
    if (threshold == null || threshold < 0) {
      emit(state.copyWith(errorMessage: 'Enter a valid stock alert'));
      return;
    }
    final settings = StoreSettings(
      storeName: state.storeName.trim(),
      supportEmail: state.supportEmail.trim(),
      supportPhone: state.supportPhone.trim(),
      gstin: state.gstin.trim(),
      currency: state.currency.trim(),
      lowStockThreshold: threshold,
      orderPrefix: state.orderPrefix.trim(),
    );
    emit(
      SettingsState.fromSettings(settings).copyWith(notice: 'Settings saved'),
    );
  }
}

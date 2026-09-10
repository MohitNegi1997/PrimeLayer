import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/settings/domain/store_settings.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.settings,
    required this.storeName,
    required this.supportEmail,
    required this.supportPhone,
    required this.gstin,
    required this.currency,
    required this.lowStockThreshold,
    required this.orderPrefix,
    this.notice,
    this.errorMessage,
  });

  factory SettingsState.fromSettings(StoreSettings settings) {
    return SettingsState(
      settings: settings,
      storeName: settings.storeName,
      supportEmail: settings.supportEmail,
      supportPhone: settings.supportPhone,
      gstin: settings.gstin,
      currency: settings.currency,
      lowStockThreshold: '${settings.lowStockThreshold}',
      orderPrefix: settings.orderPrefix,
    );
  }

  final StoreSettings settings;
  final String storeName;
  final String supportEmail;
  final String supportPhone;
  final String gstin;
  final String currency;
  final String lowStockThreshold;
  final String orderPrefix;
  final String? notice;
  final String? errorMessage;

  int get threshold {
    return int.tryParse(lowStockThreshold.trim()) ?? settings.lowStockThreshold;
  }

  SettingsState copyWith({
    StoreSettings? settings,
    String? storeName,
    String? supportEmail,
    String? supportPhone,
    String? gstin,
    String? currency,
    String? lowStockThreshold,
    String? orderPrefix,
    String? notice,
    String? errorMessage,
    bool clearNotice = false,
    bool clearError = false,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      storeName: storeName ?? this.storeName,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      gstin: gstin ?? this.gstin,
      currency: currency ?? this.currency,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      orderPrefix: orderPrefix ?? this.orderPrefix,
      notice: clearNotice ? null : notice ?? this.notice,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    settings,
    storeName,
    supportEmail,
    supportPhone,
    gstin,
    currency,
    lowStockThreshold,
    orderPrefix,
    notice,
    errorMessage,
  ];
}

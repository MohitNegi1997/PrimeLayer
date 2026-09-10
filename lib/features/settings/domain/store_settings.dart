import 'package:equatable/equatable.dart';

class StoreSettings extends Equatable {
  const StoreSettings({
    required this.storeName,
    required this.supportEmail,
    required this.supportPhone,
    required this.gstin,
    required this.currency,
    required this.lowStockThreshold,
    required this.orderPrefix,
  });

  final String storeName;
  final String supportEmail;
  final String supportPhone;
  final String gstin;
  final String currency;
  final int lowStockThreshold;
  final String orderPrefix;

  StoreSettings copyWith({
    String? storeName,
    String? supportEmail,
    String? supportPhone,
    String? gstin,
    String? currency,
    int? lowStockThreshold,
    String? orderPrefix,
  }) {
    return StoreSettings(
      storeName: storeName ?? this.storeName,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      gstin: gstin ?? this.gstin,
      currency: currency ?? this.currency,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      orderPrefix: orderPrefix ?? this.orderPrefix,
    );
  }

  @override
  List<Object?> get props => [
    storeName,
    supportEmail,
    supportPhone,
    gstin,
    currency,
    lowStockThreshold,
    orderPrefix,
  ];
}

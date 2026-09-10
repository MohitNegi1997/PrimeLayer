import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment_method.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment_status.dart';

class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.customerId,
    required this.amount,
    required this.method,
    required this.status,
    required this.paidAt,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final String customerId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime paidAt;

  String get amountLabel => '₹${amount.toStringAsFixed(0)}';

  Payment copyWith({
    String? id,
    String? orderId,
    String? orderNumber,
    String? customerId,
    double? amount,
    PaymentMethod? method,
    PaymentStatus? status,
    DateTime? paidAt,
  }) {
    return Payment(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    orderNumber,
    customerId,
    amount,
    method,
    status,
    paidAt,
  ];
}

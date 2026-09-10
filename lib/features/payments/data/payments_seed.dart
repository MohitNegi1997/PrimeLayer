import 'package:primelayer_admin_panel/features/payments/domain/payment.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment_method.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment_status.dart';

abstract final class PaymentsSeed {
  static final List<Payment> payments = [
    _p('pay-1001', 'o-1001', 'PL-1001', 'c-01', 899, PaymentMethod.upi, PaymentStatus.paid, DateTime(2026, 8, 28, 11)),
    _p('pay-1002', 'o-1002', 'PL-1002', 'c-02', 998, PaymentMethod.card, PaymentStatus.paid, DateTime(2026, 9, 2, 14)),
    _p('pay-1003', 'o-1003', 'PL-1003', 'c-03', 597, PaymentMethod.upi, PaymentStatus.pending, DateTime(2026, 9, 4, 9)),
    _p('pay-1004', 'o-1004', 'PL-1004', 'c-04', 349, PaymentMethod.cod, PaymentStatus.pending, DateTime(2026, 9, 5, 16)),
    _p('pay-1005', 'o-1005', 'PL-1005', 'c-05', 2499, PaymentMethod.netbanking, PaymentStatus.paid, DateTime(2026, 8, 20, 12)),
    _p('pay-1006', 'o-1006', 'PL-1006', 'c-06', 749, PaymentMethod.card, PaymentStatus.refunded, DateTime(2026, 9, 1, 18)),
    _p('pay-1007', 'o-1007', 'PL-1007', 'c-07', 1198, PaymentMethod.upi, PaymentStatus.paid, DateTime(2026, 9, 6, 10)),
    _p('pay-1008', 'o-1008', 'PL-1008', 'c-01', 899, PaymentMethod.upi, PaymentStatus.pending, DateTime(2026, 9, 8, 15)),
    _p('pay-1009', 'o-1009', 'PL-1009', 'c-08', 916, PaymentMethod.card, PaymentStatus.paid, DateTime(2026, 8, 30, 13)),
    _p('pay-1010', 'o-1010', 'PL-1010', 'c-09', 649, PaymentMethod.upi, PaymentStatus.paid, DateTime(2026, 9, 7, 11)),
    _p('pay-1011', 'o-1011', 'PL-1011', 'c-10', 745, PaymentMethod.cod, PaymentStatus.pending, DateTime(2026, 9, 9, 8)),
    _p('pay-1012', 'o-1012', 'PL-1012', 'c-11', 1299, PaymentMethod.upi, PaymentStatus.paid, DateTime(2026, 9, 9, 19)),
  ];

  static Payment _p(
    String id,
    String orderId,
    String orderNumber,
    String customerId,
    double amount,
    PaymentMethod method,
    PaymentStatus status,
    DateTime paidAt,
  ) {
    return Payment(
      id: id,
      orderId: orderId,
      orderNumber: orderNumber,
      customerId: customerId,
      amount: amount,
      method: method,
      status: status,
      paidAt: paidAt,
    );
  }
}

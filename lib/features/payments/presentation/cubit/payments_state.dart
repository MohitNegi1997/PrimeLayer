import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment.dart';
import 'package:primelayer_admin_panel/features/payments/domain/payment_status.dart';

class PaymentsState extends Equatable {
  const PaymentsState({
    required this.payments,
    this.query = '',
    this.status,
    this.page = 0,
    this.notice,
  });

  final List<Payment> payments;
  final String query;
  final PaymentStatus? status;
  final int page;
  final String? notice;

  List<Payment> get filteredPayments {
    final needle = query.trim().toLowerCase();
    return [
      for (final payment in payments)
        if (_matches(payment, needle)) payment,
    ];
  }

  int get safePage => PageSlice.clampPage(page, filteredPayments.length);

  List<Payment> get pagedPayments =>
      PageSlice.of(filteredPayments, safePage);

  bool _matches(Payment payment, String needle) {
    if (status != null && payment.status != status) return false;
    if (needle.isEmpty) return true;
    return payment.orderNumber.toLowerCase().contains(needle) ||
        payment.id.toLowerCase().contains(needle);
  }

  PaymentsState copyWith({
    List<Payment>? payments,
    String? query,
    PaymentStatus? status,
    int? page,
    String? notice,
    bool clearStatus = false,
    bool clearNotice = false,
  }) {
    return PaymentsState(
      payments: payments ?? this.payments,
      query: query ?? this.query,
      status: clearStatus ? null : status ?? this.status,
      page: page ?? this.page,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [payments, query, status, page, notice];
}

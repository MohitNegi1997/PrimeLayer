enum PaymentStatus {
  pending,
  paid,
  refunded,
  failed;

  String get label => switch (this) {
    PaymentStatus.pending => 'Pending',
    PaymentStatus.paid => 'Paid',
    PaymentStatus.refunded => 'Refunded',
    PaymentStatus.failed => 'Failed',
  };
}

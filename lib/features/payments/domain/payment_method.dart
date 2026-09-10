enum PaymentMethod {
  upi,
  card,
  cod,
  netbanking;

  String get label => switch (this) {
    PaymentMethod.upi => 'UPI',
    PaymentMethod.card => 'Card',
    PaymentMethod.cod => 'COD',
    PaymentMethod.netbanking => 'Net banking',
  };
}

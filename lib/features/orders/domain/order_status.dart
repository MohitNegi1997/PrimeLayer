enum OrderStatus {
  placed,
  printing,
  packed,
  shipped,
  delivered,
  cancelled;

  String get label => switch (this) {
    OrderStatus.placed => 'New',
    OrderStatus.printing => 'Printing',
    OrderStatus.packed => 'Packed',
    OrderStatus.shipped => 'Shipped',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.cancelled => 'Cancelled',
  };
}

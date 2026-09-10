import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';

class OrdersState extends Equatable {
  const OrdersState({
    required this.orders,
    this.query = '',
    this.status,
    this.page = 0,
    this.notice,
  });

  final List<ShopOrder> orders;
  final String query;
  final OrderStatus? status;
  final int page;
  final String? notice;

  List<ShopOrder> get filteredOrders {
    final needle = query.trim().toLowerCase();
    return [
      for (final order in orders)
        if (_matches(order, needle)) order,
    ];
  }

  int get safePage => PageSlice.clampPage(page, filteredOrders.length);

  List<ShopOrder> get pagedOrders => PageSlice.of(filteredOrders, safePage);

  int countForCustomer(String customerId) {
    var count = 0;
    for (final order in orders) {
      if (order.customerId == customerId) count += 1;
    }
    return count;
  }

  ShopOrder? byId(String id) {
    for (final order in orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  double get paidRevenue {
    var sum = 0.0;
    for (final order in orders) {
      if (order.status == OrderStatus.cancelled) continue;
      sum += order.subtotal;
    }
    return sum;
  }

  bool _matches(ShopOrder order, String needle) {
    if (status != null && order.status != status) return false;
    if (needle.isEmpty) return true;
    return order.number.toLowerCase().contains(needle) ||
        order.customerId.contains(needle);
  }

  OrdersState copyWith({
    List<ShopOrder>? orders,
    String? query,
    OrderStatus? status,
    int? page,
    String? notice,
    bool clearStatus = false,
    bool clearNotice = false,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      query: query ?? this.query,
      status: clearStatus ? null : status ?? this.status,
      page: page ?? this.page,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [orders, query, status, page, notice];
}

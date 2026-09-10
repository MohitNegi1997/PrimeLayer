import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/orders/data/orders_seed.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersState(orders: OrdersSeed.orders));

  void searchChanged(String query) {
    emit(state.copyWith(query: query, page: 0, clearNotice: true));
  }

  void statusChanged(OrderStatus? status) {
    emit(
      state.copyWith(
        status: status,
        clearStatus: status == null,
        page: 0,
        clearNotice: true,
      ),
    );
  }

  void pageChanged(int page) {
    emit(state.copyWith(page: page, clearNotice: true));
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void save(ShopOrder order) {
    final items = [...state.orders];
    final index = items.indexWhere((item) => item.id == order.id);
    if (index == -1) {
      items.insert(0, order);
    } else {
      items[index] = order;
    }
    emit(state.copyWith(orders: items, notice: '${order.number} saved'));
  }

  void updateStatus(String id, OrderStatus status) {
    emit(
      state.copyWith(
        orders: [
          for (final order in state.orders)
            if (order.id == id) order.copyWith(status: status) else order,
        ],
        notice: 'Order status updated',
      ),
    );
  }

  void delete(String id) {
    final matches = state.orders.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final order = matches.first;
    emit(
      state.copyWith(
        orders: [
          for (final item in state.orders)
            if (item.id != id) item,
        ],
        notice: '${order.number} deleted',
      ),
    );
  }
}

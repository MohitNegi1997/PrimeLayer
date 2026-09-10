import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/customers/data/customers_seed.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit()
    : super(CustomersState(customers: CustomersSeed.customers));

  void searchChanged(String query) {
    emit(state.copyWith(query: query, page: 0, clearNotice: true));
  }

  void pageChanged(int page) {
    emit(state.copyWith(page: page, clearNotice: true));
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void save(Customer customer) {
    final items = [...state.customers];
    final index = items.indexWhere((item) => item.id == customer.id);
    if (index == -1) {
      items.add(customer);
    } else {
      items[index] = customer;
    }
    emit(state.copyWith(customers: items, notice: '${customer.name} saved'));
  }

  void delete(String id) {
    final matches = state.customers.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final customer = matches.first;
    emit(
      state.copyWith(
        customers: [
          for (final item in state.customers)
            if (item.id != id) item,
        ],
        notice: '${customer.name} deleted',
      ),
    );
  }
}

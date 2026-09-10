import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/inventory/presentation/cubit/inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(const InventoryState());

  void searchChanged(String query) {
    emit(state.copyWith(query: query, page: 0));
  }

  void lowStockOnlyChanged(bool value) {
    emit(state.copyWith(lowStockOnly: value, page: 0));
  }

  void pageChanged(int page) {
    emit(state.copyWith(page: page));
  }
}

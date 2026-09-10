import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/shipping/data/shipping_seed.dart';
import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_state.dart';

class ShippingCubit extends Cubit<ShippingState> {
  ShippingCubit() : super(const ShippingState(methods: ShippingSeed.methods));

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void toggleActive(String id) {
    emit(
      state.copyWith(
        methods: [
          for (final method in state.methods)
            if (method.id == id)
              method.copyWith(isActive: !method.isActive)
            else
              method,
        ],
        clearNotice: true,
      ),
    );
  }

  void save(ShippingMethod method) {
    final items = [...state.methods];
    final index = items.indexWhere((item) => item.id == method.id);
    if (index == -1) {
      items.add(method);
    } else {
      items[index] = method;
    }
    emit(state.copyWith(methods: items, notice: '${method.name} saved'));
  }

  void delete(String id) {
    final matches = state.methods.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final method = matches.first;
    emit(
      state.copyWith(
        methods: [
          for (final item in state.methods)
            if (item.id != id) item,
        ],
        notice: '${method.name} deleted',
      ),
    );
  }
}

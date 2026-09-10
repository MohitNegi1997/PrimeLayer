import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/products/data/products_seed.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_state.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_visibility_filter.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsState(products: ProductsSeed.products));

  void searchChanged(String query) {
    emit(state.copyWith(query: query, page: 0, clearNotice: true));
  }

  void categoryFilterChanged(String? categoryId) {
    emit(
      state.copyWith(
        categoryId: categoryId,
        clearCategoryId: categoryId == null,
        page: 0,
        clearNotice: true,
      ),
    );
  }

  void filterChanged(ProductVisibilityFilter filter) {
    emit(state.copyWith(filter: filter, page: 0, clearNotice: true));
  }

  void pageChanged(int page) {
    emit(state.copyWith(page: page, clearNotice: true));
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void toggleVisibility(String id) {
    emit(
      state.copyWith(
        products: [
          for (final product in state.products)
            if (product.id == id)
              product.copyWith(isVisible: !product.isVisible)
            else
              product,
        ],
        clearNotice: true,
      ),
    );
  }

  void save(Product product) {
    final items = [...state.products];
    final index = items.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      items.insert(0, product);
      emit(
        state.copyWith(
          products: items,
          page: 0,
          notice: '${product.name} saved',
        ),
      );
      return;
    }
    items[index] = product;
    emit(state.copyWith(products: items, notice: '${product.name} saved'));
  }

  void updateStock({
    required String productId,
    required String variantId,
    required int stock,
  }) {
    emit(
      state.copyWith(
        products: [
          for (final product in state.products)
            if (product.id == productId)
              product.copyWith(
                variants: [
                  for (final variant in product.variants)
                    if (variant.id == variantId)
                      variant.copyWith(stock: stock)
                    else
                      variant,
                ],
              )
            else
              product,
        ],
        notice: 'Stock updated',
      ),
    );
  }

  void delete(String id) {
    final matches = state.products.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final product = matches.first;
    emit(
      state.copyWith(
        products: [
          for (final item in state.products)
            if (item.id != id) item,
        ],
        notice: '${product.name} deleted',
      ),
    );
  }
}

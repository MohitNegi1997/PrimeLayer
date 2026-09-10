import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_variant_form_state.dart';

class ProductVariantFormCubit extends Cubit<ProductVariantFormState> {
  ProductVariantFormCubit({
    ProductVariant? variant,
    required List<String> existingSkus,
  }) : super(
         variant == null
             ? ProductVariantFormState(existingSkus: existingSkus)
             : ProductVariantFormState(
                 id: variant.id,
                 name: variant.name,
                 sku: variant.sku,
                 price: variant.price.toStringAsFixed(0),
                 size: variant.size ?? '',
                 color: variant.color ?? '',
                 material: variant.material ?? '',
                 stock: variant.stock.toString(),
                 existingSkus: existingSkus,
               ),
       );

  void nameChanged(String name) {
    emit(
      state.copyWith(
        name: name,
        status: ProductVariantFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void skuChanged(String sku) {
    emit(
      state.copyWith(
        sku: sku,
        status: ProductVariantFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void priceChanged(String price) {
    emit(
      state.copyWith(
        price: price,
        status: ProductVariantFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void sizeChanged(String size) {
    emit(
      state.copyWith(
        size: size,
        status: ProductVariantFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void colorChanged(String color) {
    emit(
      state.copyWith(
        color: color,
        status: ProductVariantFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void stockChanged(String stock) {
    emit(
      state.copyWith(
        stock: stock,
        status: ProductVariantFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void materialChanged(String material) {
    emit(
      state.copyWith(
        material: material,
        status: ProductVariantFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    final name = state.name.trim();
    final sku = state.sku.trim();
    final price = double.tryParse(state.price.trim());
    if (name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a name'));
      return;
    }
    if (sku.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a SKU'));
      return;
    }
    if (state.existingSkus.contains(sku)) {
      emit(state.copyWith(errorMessage: 'SKU already in use'));
      return;
    }
    if (price == null || price < 0) {
      emit(state.copyWith(errorMessage: 'Enter a valid price'));
      return;
    }
    final stock = int.tryParse(state.stock.trim());
    if (stock == null || stock < 0) {
      emit(state.copyWith(errorMessage: 'Enter valid stock'));
      return;
    }
    emit(
      state.copyWith(
        status: ProductVariantFormStatus.success,
        clearError: true,
      ),
    );
  }
}

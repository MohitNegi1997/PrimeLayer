import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/domain/shop_order.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/order_form_cubit.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/order_form_state.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_cubit.dart';

class OrderEditorDialog extends StatelessWidget {
  const OrderEditorDialog({super.key});

  static Future<void> open(BuildContext context, {ShopOrder? order}) {
    final customers = context.read<CustomersCubit>().state.customers;
    final products = context.read<ProductsCubit>().state.products;
    final shipping = context.read<ShippingCubit>().state.methods;
    final firstProduct = products.isEmpty ? null : products.first;
    final firstVariant = firstProduct == null || firstProduct.variants.isEmpty
        ? null
        : firstProduct.variants.first;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<OrdersCubit>()),
            BlocProvider.value(value: context.read<CustomersCubit>()),
            BlocProvider.value(value: context.read<ProductsCubit>()),
            BlocProvider.value(value: context.read<ShippingCubit>()),
            BlocProvider(
              create: (_) => OrderFormCubit(
                order: order,
                defaultCustomerId: customers.isEmpty ? '' : customers.first.id,
                defaultProductId: firstProduct?.id ?? '',
                defaultVariantId: firstVariant?.id ?? '',
                defaultShippingId: shipping.isEmpty ? '' : shipping.first.id,
              ),
            ),
          ],
          child: const OrderEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<OrderFormCubit>();
    final products = context.read<ProductsCubit>().state.products;

    return Dialog(
      child: BlocListener<OrderFormCubit, OrderFormState>(
        listenWhen: (previous, current) =>
            current.formStatus == OrderFormStatus.success,
        listener: (context, state) {
          context.read<OrdersCubit>().save(state.toOrder(products));
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: 520,
          height: MediaQuery.sizeOf(context).height * 0.82,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  formCubit.state.isEditing ? 'Edit order' : 'Add order',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _customerField(context),
                        const SizedBox(height: 16),
                        _shippingField(context),
                        const SizedBox(height: 16),
                        _statusField(),
                        if (!formCubit.state.isEditing) ...[
                          const SizedBox(height: 16),
                          _productField(context),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: formCubit.state.quantity,
                            keyboardType: TextInputType.number,
                            onChanged: formCubit.quantityChanged,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                            ),
                          ),
                        ],
                        if (formCubit.state.isEditing) ...[
                          const SizedBox(height: 16),
                          Text('Items', style: theme.textTheme.titleMedium),
                          for (final item in formCubit.state.existingItems)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(item.name),
                              subtitle: Text(
                                '${item.sku} · ×${item.quantity} · ₹${item.lineTotal.toStringAsFixed(0)}',
                              ),
                            ),
                        ],
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: formCubit.state.notes,
                          minLines: 2,
                          maxLines: 3,
                          onChanged: formCubit.notesChanged,
                          decoration: const InputDecoration(labelText: 'Notes'),
                        ),
                      ],
                    ),
                  ),
                ),
                _errorText(theme),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: formCubit.submit,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customerField(BuildContext context) {
    final customers = context.read<CustomersCubit>().state.customers;
    return BlocBuilder<OrderFormCubit, OrderFormState>(
      buildWhen: (previous, current) =>
          previous.customerId != current.customerId,
      builder: (context, state) {
        return _dropdown(
          label: 'Customer',
          value: _safeValue(customers, state.customerId, (item) => item.id),
          items: [
            for (final Customer customer in customers)
              DropdownMenuItem(value: customer.id, child: Text(customer.name)),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<OrderFormCubit>().customerChanged(value);
            }
          },
        );
      },
    );
  }

  Widget _shippingField(BuildContext context) {
    final methods = context.read<ShippingCubit>().state.methods;
    return BlocBuilder<OrderFormCubit, OrderFormState>(
      buildWhen: (previous, current) =>
          previous.shippingMethodId != current.shippingMethodId,
      builder: (context, state) {
        return _dropdown(
          label: 'Shipping',
          value: _safeValue(methods, state.shippingMethodId, (item) => item.id),
          items: [
            for (final ShippingMethod method in methods)
              DropdownMenuItem(value: method.id, child: Text(method.name)),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<OrderFormCubit>().shippingChanged(value);
            }
          },
        );
      },
    );
  }

  Widget _statusField() {
    return BlocBuilder<OrderFormCubit, OrderFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return DropdownButtonFormField<OrderStatus>(
          key: ValueKey(state.status),
          initialValue: state.status,
          decoration: const InputDecoration(labelText: 'Status'),
          items: [
            for (final value in OrderStatus.values)
              DropdownMenuItem(value: value, child: Text(value.label)),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<OrderFormCubit>().statusChanged(value);
            }
          },
        );
      },
    );
  }

  Widget _productField(BuildContext context) {
    final products = [
      for (final product in context.read<ProductsCubit>().state.products)
        if (product.variants.isNotEmpty) product,
    ];
    return BlocBuilder<OrderFormCubit, OrderFormState>(
      buildWhen: (previous, current) => previous.productId != current.productId,
      builder: (context, state) {
        return _dropdown(
          label: 'Product',
          value: _safeValue(products, state.productId, (item) => item.id),
          items: [
            for (final Product product in products)
              DropdownMenuItem(
                value: product.id,
                child: Text('${product.name} · ${product.variants.first.sku}'),
              ),
          ],
          onChanged: (value) {
            if (value == null) return;
            final product = products.firstWhere((item) => item.id == value);
            context.read<OrderFormCubit>().productChanged(
              product.id,
              product.variants.first.id,
            );
          },
        );
      },
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    if (items.isEmpty) {
      return Text('No $label options');
    }
    return DropdownButtonFormField<String>(
      key: ValueKey(value),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: items,
      onChanged: onChanged,
    );
  }

  String? _safeValue<T>(
    List<T> items,
    String current,
    String Function(T item) idOf,
  ) {
    for (final item in items) {
      if (idOf(item) == current) return current;
    }
    return items.isEmpty ? null : idOf(items.first);
  }

  Widget _errorText(ThemeData theme) {
    return BlocBuilder<OrderFormCubit, OrderFormState>(
      buildWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.errorMessage == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            state.errorMessage!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        );
      },
    );
  }
}

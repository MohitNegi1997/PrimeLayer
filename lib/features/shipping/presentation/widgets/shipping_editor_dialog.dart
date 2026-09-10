import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/shipping/domain/shipping_method.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_form_cubit.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_form_state.dart';

class ShippingEditorDialog extends StatelessWidget {
  const ShippingEditorDialog({super.key});

  static Future<void> open(BuildContext context, {ShippingMethod? method}) {
    final cubit = context.read<ShippingCubit>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (_) => ShippingFormCubit(method: method)),
          ],
          child: const ShippingEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<ShippingFormCubit>();

    return Dialog(
      child: BlocListener<ShippingFormCubit, ShippingFormState>(
        listenWhen: (previous, current) =>
            current.status == ShippingFormStatus.success,
        listener: (context, state) {
          context.read<ShippingCubit>().save(state.toMethod());
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: 440,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  formCubit.state.isEditing ? 'Edit method' : 'Add method',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: formCubit.state.name,
                  onChanged: formCubit.nameChanged,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.eta,
                  onChanged: formCubit.etaChanged,
                  decoration: const InputDecoration(labelText: 'ETA'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.price,
                  keyboardType: TextInputType.number,
                  onChanged: formCubit.priceChanged,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                BlocBuilder<ShippingFormCubit, ShippingFormState>(
                  buildWhen: (previous, current) =>
                      previous.isActive != current.isActive,
                  builder: (context, state) {
                    return SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Active'),
                      value: state.isActive,
                      onChanged: formCubit.activeChanged,
                    );
                  },
                ),
                BlocBuilder<ShippingFormCubit, ShippingFormState>(
                  buildWhen: (previous, current) =>
                      previous.errorMessage != current.errorMessage,
                  builder: (context, state) {
                    if (state.errorMessage == null) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    );
                  },
                ),
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
}

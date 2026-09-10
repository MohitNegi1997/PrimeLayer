import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customer_form_cubit.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customer_form_state.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';

class CustomerEditorDialog extends StatelessWidget {
  const CustomerEditorDialog({super.key});

  static Future<void> open(BuildContext context, {Customer? customer}) {
    final cubit = context.read<CustomersCubit>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (_) => CustomerFormCubit(customer: customer)),
          ],
          child: const CustomerEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<CustomerFormCubit>();
    final isEditing = formCubit.state.isEditing;

    return Dialog(
      child: BlocListener<CustomerFormCubit, CustomerFormState>(
        listenWhen: (previous, current) =>
            current.status == CustomerFormStatus.success,
        listener: (context, state) {
          context.read<CustomersCubit>().save(state.toCustomer());
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: 480,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Edit customer' : 'Add customer',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: formCubit.state.name,
                  textInputAction: TextInputAction.next,
                  onChanged: formCubit.nameChanged,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.email,
                  textInputAction: TextInputAction.next,
                  onChanged: formCubit.emailChanged,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.phone,
                  textInputAction: TextInputAction.next,
                  onChanged: formCubit.phoneChanged,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formCubit.state.city,
                  onChanged: formCubit.cityChanged,
                  decoration: const InputDecoration(labelText: 'City'),
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

  Widget _errorText(ThemeData theme) {
    return BlocBuilder<CustomerFormCubit, CustomerFormState>(
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

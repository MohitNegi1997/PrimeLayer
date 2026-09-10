import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_role.dart';
import 'package:primelayer_admin_panel/features/users/domain/staff_user.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/staff_form_cubit.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/staff_form_state.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/users_cubit.dart';

class StaffEditorDialog extends StatelessWidget {
  const StaffEditorDialog({super.key});

  static Future<void> open(BuildContext context, {StaffUser? user}) {
    final cubit = context.read<UsersCubit>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (_) => StaffFormCubit(user: user)),
          ],
          child: const StaffEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<StaffFormCubit>();

    return Dialog(
      child: BlocListener<StaffFormCubit, StaffFormState>(
        listenWhen: (previous, current) =>
            current.status == StaffFormStatus.success,
        listener: (context, state) {
          context.read<UsersCubit>().save(state.toUser());
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
                  formCubit.state.id == null ? 'Add user' : 'Edit user',
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
                  initialValue: formCubit.state.email,
                  onChanged: formCubit.emailChanged,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                BlocBuilder<StaffFormCubit, StaffFormState>(
                  buildWhen: (previous, current) =>
                      previous.role != current.role,
                  builder: (context, state) {
                    return DropdownButtonFormField<StaffRole>(
                      key: ValueKey(state.role),
                      initialValue: state.role,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: [
                        for (final role in StaffRole.values)
                          DropdownMenuItem(
                            value: role,
                            child: Text(role.label),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) formCubit.roleChanged(value);
                      },
                    );
                  },
                ),
                BlocBuilder<StaffFormCubit, StaffFormState>(
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
                BlocBuilder<StaffFormCubit, StaffFormState>(
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

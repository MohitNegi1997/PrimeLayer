import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_page_scaffold.dart';
import 'package:primelayer_admin_panel/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:primelayer_admin_panel/features/settings/presentation/cubit/settings_state.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<SettingsCubit>().clearNotice();
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          return AdminPageScaffold(
            title: 'Settings',
            subtitle: 'Store identity, support contacts, and stock alerts.',
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: ValueKey('store-${state.settings.storeName}'),
                      initialValue: state.storeName,
                      onChanged: cubit.storeNameChanged,
                      decoration: const InputDecoration(
                        labelText: 'Store name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: ValueKey('email-${state.settings.supportEmail}'),
                      initialValue: state.supportEmail,
                      onChanged: cubit.supportEmailChanged,
                      decoration: const InputDecoration(
                        labelText: 'Support email',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: ValueKey('phone-${state.settings.supportPhone}'),
                      initialValue: state.supportPhone,
                      onChanged: cubit.supportPhoneChanged,
                      decoration: const InputDecoration(
                        labelText: 'Support phone',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: ValueKey('gstin-${state.settings.gstin}'),
                      initialValue: state.gstin,
                      onChanged: cubit.gstinChanged,
                      decoration: const InputDecoration(
                        labelText: 'GSTIN',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: ValueKey('currency-${state.settings.currency}'),
                      initialValue: state.currency,
                      onChanged: cubit.currencyChanged,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: ValueKey(
                        'stock-${state.settings.lowStockThreshold}',
                      ),
                      initialValue: state.lowStockThreshold,
                      keyboardType: TextInputType.number,
                      onChanged: cubit.lowStockChanged,
                      decoration: const InputDecoration(
                        labelText: 'Low stock alert',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: ValueKey(
                        'prefix-${state.settings.orderPrefix}',
                      ),
                      initialValue: state.orderPrefix,
                      onChanged: cubit.orderPrefixChanged,
                      decoration: const InputDecoration(
                        labelText: 'Order prefix',
                      ),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: cubit.save,
                        child: const Text('Save settings'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';

class CustomersToolbar extends StatelessWidget {
  const CustomersToolbar({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final title = Text('Customers', style: theme.textTheme.titleLarge);
    final addButton = ElevatedButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add),
      label: const Text('Add customer'),
    );
    final search = TextField(
      onChanged: context.read<CustomersCubit>().searchChanged,
      decoration: const InputDecoration(
        labelText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 12),
          addButton,
          const SizedBox(height: 12),
          search,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: title),
            addButton,
          ],
        ),
        const SizedBox(height: 16),
        search,
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/inventory/presentation/cubit/inventory_cubit.dart';
import 'package:primelayer_admin_panel/features/inventory/presentation/widgets/inventory_view.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InventoryCubit(),
      child: const InventoryView(),
    );
  }
}

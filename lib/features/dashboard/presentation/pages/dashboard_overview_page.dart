import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_overview_cubit.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_overview_view.dart';

class DashboardOverviewPage extends StatelessWidget {
  const DashboardOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardOverviewCubit(),
      child: const DashboardOverviewView(),
    );
  }
}

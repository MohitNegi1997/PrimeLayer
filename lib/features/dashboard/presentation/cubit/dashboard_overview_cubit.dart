import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_overview_data.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_overview_state.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_period.dart';

class DashboardOverviewCubit extends Cubit<DashboardOverviewState> {
  DashboardOverviewCubit()
    : super(DashboardOverviewData.forPeriod(DashboardPeriod.sevenDays));

  void selectPeriod(DashboardPeriod period) {
    emit(DashboardOverviewData.forPeriod(period));
  }
}

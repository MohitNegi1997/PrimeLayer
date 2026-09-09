import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_chart_point.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_period.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_print_bar.dart';

class DashboardOverviewState extends Equatable {
  const DashboardOverviewState({
    required this.period,
    required this.revenue,
    required this.orderStatus,
    required this.printFloor,
    required this.topProducts,
  });

  final DashboardPeriod period;
  final List<DashboardChartPoint> revenue;
  final List<DashboardChartPoint> orderStatus;
  final List<DashboardPrintBar> printFloor;
  final List<DashboardChartPoint> topProducts;

  @override
  List<Object?> get props => [
    period,
    revenue,
    orderStatus,
    printFloor,
    topProducts,
  ];
}

import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_chart_point.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_overview_state.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_period.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_print_bar.dart';

abstract final class DashboardOverviewData {
  static DashboardOverviewState forPeriod(DashboardPeriod period) {
    return switch (period) {
      DashboardPeriod.today => _today,
      DashboardPeriod.sevenDays => _sevenDays,
      DashboardPeriod.thirtyDays => _thirtyDays,
    };
  }

  static const DashboardOverviewState _today = DashboardOverviewState(
    period: DashboardPeriod.today,
    revenue: [
      DashboardChartPoint(label: '9a', value: 800),
      DashboardChartPoint(label: '11a', value: 1400),
      DashboardChartPoint(label: '1p', value: 2200),
      DashboardChartPoint(label: '3p', value: 1800),
      DashboardChartPoint(label: '5p', value: 2600),
      DashboardChartPoint(label: '7p', value: 3100),
      DashboardChartPoint(label: '9p', value: 1500),
    ],
    orderStatus: [
      DashboardChartPoint(label: 'New', value: 4),
      DashboardChartPoint(label: 'Printing', value: 3),
      DashboardChartPoint(label: 'Packed', value: 2),
      DashboardChartPoint(label: 'Shipped', value: 6),
      DashboardChartPoint(label: 'Cancelled', value: 1),
    ],
    printFloor: [
      DashboardPrintBar(label: 'Alpha', queued: 2, printing: 1, failed: 0),
      DashboardPrintBar(label: 'Beta', queued: 1, printing: 1, failed: 1),
      DashboardPrintBar(label: 'Gamma', queued: 3, printing: 0, failed: 0),
    ],
    topProducts: [
      DashboardChartPoint(label: 'Dragon', value: 9),
      DashboardChartPoint(label: 'Stand', value: 7),
      DashboardChartPoint(label: 'Keycap', value: 5),
      DashboardChartPoint(label: 'Planter', value: 4),
      DashboardChartPoint(label: 'Chess', value: 3),
    ],
  );

  static const DashboardOverviewState _sevenDays = DashboardOverviewState(
    period: DashboardPeriod.sevenDays,
    revenue: [
      DashboardChartPoint(label: 'Mon', value: 12400),
      DashboardChartPoint(label: 'Tue', value: 9800),
      DashboardChartPoint(label: 'Wed', value: 15200),
      DashboardChartPoint(label: 'Thu', value: 11000),
      DashboardChartPoint(label: 'Fri', value: 17600),
      DashboardChartPoint(label: 'Sat', value: 21000),
      DashboardChartPoint(label: 'Sun', value: 8900),
    ],
    orderStatus: [
      DashboardChartPoint(label: 'New', value: 18),
      DashboardChartPoint(label: 'Printing', value: 12),
      DashboardChartPoint(label: 'Packed', value: 9),
      DashboardChartPoint(label: 'Shipped', value: 41),
      DashboardChartPoint(label: 'Cancelled', value: 4),
    ],
    printFloor: [
      DashboardPrintBar(label: 'Mon', queued: 6, printing: 4, failed: 1),
      DashboardPrintBar(label: 'Tue', queued: 5, printing: 3, failed: 0),
      DashboardPrintBar(label: 'Wed', queued: 8, printing: 5, failed: 2),
      DashboardPrintBar(label: 'Thu', queued: 4, printing: 4, failed: 1),
      DashboardPrintBar(label: 'Fri', queued: 9, printing: 6, failed: 1),
      DashboardPrintBar(label: 'Sat', queued: 11, printing: 7, failed: 2),
      DashboardPrintBar(label: 'Sun', queued: 3, printing: 2, failed: 0),
    ],
    topProducts: [
      DashboardChartPoint(label: 'Dragon', value: 42),
      DashboardChartPoint(label: 'Stand', value: 31),
      DashboardChartPoint(label: 'Keycap', value: 24),
      DashboardChartPoint(label: 'Planter', value: 18),
      DashboardChartPoint(label: 'Chess', value: 15),
    ],
  );

  static const DashboardOverviewState _thirtyDays = DashboardOverviewState(
    period: DashboardPeriod.thirtyDays,
    revenue: [
      DashboardChartPoint(label: '1', value: 9200),
      DashboardChartPoint(label: '2', value: 11000),
      DashboardChartPoint(label: '3', value: 8700),
      DashboardChartPoint(label: '4', value: 13400),
      DashboardChartPoint(label: '5', value: 15600),
      DashboardChartPoint(label: '6', value: 12100),
      DashboardChartPoint(label: '7', value: 9800),
      DashboardChartPoint(label: '8', value: 14200),
      DashboardChartPoint(label: '9', value: 16800),
      DashboardChartPoint(label: '10', value: 15100),
      DashboardChartPoint(label: '11', value: 11900),
      DashboardChartPoint(label: '12', value: 17600),
      DashboardChartPoint(label: '13', value: 19200),
      DashboardChartPoint(label: '14', value: 10400),
      DashboardChartPoint(label: '15', value: 8800),
      DashboardChartPoint(label: '16', value: 12500),
      DashboardChartPoint(label: '17', value: 14900),
      DashboardChartPoint(label: '18', value: 16300),
      DashboardChartPoint(label: '19', value: 18100),
      DashboardChartPoint(label: '20', value: 21000),
      DashboardChartPoint(label: '21', value: 13200),
      DashboardChartPoint(label: '22', value: 11700),
      DashboardChartPoint(label: '23', value: 14500),
      DashboardChartPoint(label: '24', value: 17200),
      DashboardChartPoint(label: '25', value: 19800),
      DashboardChartPoint(label: '26', value: 22400),
      DashboardChartPoint(label: '27', value: 18600),
      DashboardChartPoint(label: '28', value: 15300),
      DashboardChartPoint(label: '29', value: 12800),
      DashboardChartPoint(label: '30', value: 16100),
    ],
    orderStatus: [
      DashboardChartPoint(label: 'New', value: 52),
      DashboardChartPoint(label: 'Printing', value: 38),
      DashboardChartPoint(label: 'Packed', value: 29),
      DashboardChartPoint(label: 'Shipped', value: 180),
      DashboardChartPoint(label: 'Cancelled', value: 14),
    ],
    printFloor: [
      DashboardPrintBar(label: 'W1', queued: 28, printing: 18, failed: 4),
      DashboardPrintBar(label: 'W2', queued: 31, printing: 22, failed: 5),
      DashboardPrintBar(label: 'W3', queued: 24, printing: 19, failed: 3),
      DashboardPrintBar(label: 'W4', queued: 36, printing: 25, failed: 6),
      DashboardPrintBar(label: 'W5', queued: 22, printing: 16, failed: 2),
    ],
    topProducts: [
      DashboardChartPoint(label: 'Dragon', value: 164),
      DashboardChartPoint(label: 'Stand', value: 121),
      DashboardChartPoint(label: 'Keycap', value: 98),
      DashboardChartPoint(label: 'Planter', value: 74),
      DashboardChartPoint(label: 'Chess', value: 61),
    ],
  );
}

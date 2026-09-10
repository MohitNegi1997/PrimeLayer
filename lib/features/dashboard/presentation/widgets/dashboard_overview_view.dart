import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_page_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_overview_cubit.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_overview_state.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_chart_card.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_period_toggle.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/orders_status_chart.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/print_floor_chart.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/revenue_chart.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/top_products_chart.dart';

class DashboardOverviewView extends StatelessWidget {
  const DashboardOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      builder: (context, state) {
        return AdminPageScaffold(
          title: 'Overview',
          subtitle: 'Track revenue, orders, and print floor load.',
          actions: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: DashboardPeriodToggle(
                period: state.period,
                onChanged: context.read<DashboardOverviewCubit>().selectPeriod,
              ),
            ),
          ],
          stats: _stats(state),
          child: SingleChildScrollView(
            child: _chartGrid(state, Responsive.isMobile(context)),
          ),
        );
      },
    );
  }

  List<AdminStatMetric> _stats(DashboardOverviewState state) {
    var revenue = 0.0;
    for (final point in state.revenue) {
      revenue += point.value;
    }
    var orders = 0.0;
    for (final point in state.orderStatus) {
      orders += point.value;
    }
    var printing = 0.0;
    for (final bar in state.printFloor) {
      printing += bar.printing;
    }
    final top = state.topProducts.isEmpty ? '—' : state.topProducts.first.label;
    return [
      AdminStatMetric(
        label: 'Total revenue',
        value: '₹${revenue.toStringAsFixed(0)}',
        caption: state.period.label,
        icon: Icons.payments_outlined,
        tone: AdminChipTone.success,
      ),
      AdminStatMetric(
        label: 'Total orders',
        value: orders.toStringAsFixed(0),
        caption: 'By status',
        icon: Icons.receipt_long_outlined,
      ),
      AdminStatMetric(
        label: 'Printing',
        value: printing.toStringAsFixed(0),
        caption: 'On the floor',
        icon: Icons.print_outlined,
        tone: AdminChipTone.pending,
      ),
      AdminStatMetric(
        label: 'Top product',
        value: top,
        caption: 'Best seller',
        icon: Icons.star_outline,
        tone: AdminChipTone.info,
      ),
    ];
  }

  Widget _chartGrid(DashboardOverviewState state, bool isMobile) {
    final charts = [
      DashboardChartCard(
        title: 'Revenue',
        child: RevenueChart(points: state.revenue),
      ),
      DashboardChartCard(
        title: 'Orders by status',
        child: OrdersStatusChart(slices: state.orderStatus),
      ),
      DashboardChartCard(
        title: 'Print floor',
        child: PrintFloorChart(bars: state.printFloor),
      ),
      DashboardChartCard(
        title: 'Top products',
        child: TopProductsChart(points: state.topProducts),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < charts.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            charts[i],
          ],
        ],
      );
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: charts[0]),
            const SizedBox(width: 16),
            Expanded(child: charts[1]),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: charts[2]),
            const SizedBox(width: 16),
            Expanded(child: charts[3]),
          ],
        ),
      ],
    );
  }
}

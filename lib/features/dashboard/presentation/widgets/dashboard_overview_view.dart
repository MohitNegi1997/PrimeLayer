import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
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
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context, state, isMobile),
              const SizedBox(height: 16),
              _chartGrid(state, isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    DashboardOverviewState state,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final title = Text('Overview', style: theme.textTheme.titleLarge);
    final toggle = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: DashboardPeriodToggle(
        period: state.period,
        onChanged: context.read<DashboardOverviewCubit>().selectPeriod,
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: toggle),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: title),
        toggle,
      ],
    );
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

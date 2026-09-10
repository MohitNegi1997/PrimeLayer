import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_page_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:primelayer_admin_panel/features/inventory/domain/inventory_mapper.dart';
import 'package:primelayer_admin_panel/features/orders/domain/order_status.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersCubit>().state;
    final products = context.watch<ProductsCubit>().state;
    final customers = context.watch<CustomersCubit>().state;
    final website = context.watch<WebsiteCubit>().state;
    final threshold =
        context.watch<SettingsCubit>().state.settings.lowStockThreshold;
    final rows = InventoryMapper.fromProducts(products.products);
    var lowStock = 0;
    for (final row in rows) {
      if (row.stock <= threshold) lowStock += 1;
    }
    var openOrders = 0;
    for (final order in orders.orders) {
      if (order.status != OrderStatus.delivered &&
          order.status != OrderStatus.cancelled) {
        openOrders += 1;
      }
    }
    var visibleFaqs = 0;
    for (final faq in website.faqs) {
      if (faq.isVisible) visibleFaqs += 1;
    }

    return AdminPageScaffold(
      title: 'Analytics',
      subtitle: 'Live counts from orders, catalog, customers, and the website.',
      stats: [
        AdminStatMetric(
          label: 'Revenue',
          value: '₹${orders.paidRevenue.toStringAsFixed(0)}',
          caption: 'Paid orders',
          icon: Icons.payments_outlined,
          tone: AdminChipTone.success,
        ),
        AdminStatMetric(
          label: 'Orders',
          value: '${orders.orders.length}',
          caption: 'All time',
          icon: Icons.receipt_long_outlined,
        ),
        AdminStatMetric(
          label: 'Open orders',
          value: '$openOrders',
          caption: 'Awaiting action',
          icon: Icons.hourglass_empty,
          tone: AdminChipTone.pending,
        ),
        AdminStatMetric(
          label: 'Customers',
          value: '${customers.customers.length}',
          caption: 'In CRM',
          icon: Icons.people_outline,
          tone: AdminChipTone.info,
        ),
        AdminStatMetric(
          label: 'Products',
          value: '${products.products.length}',
          caption: 'In catalog',
          icon: Icons.inventory_2_outlined,
        ),
        AdminStatMetric(
          label: 'Low stock SKUs',
          value: '$lowStock',
          caption: 'Need a restock',
          icon: Icons.warning_amber_outlined,
          tone: AdminChipTone.danger,
        ),
        AdminStatMetric(
          label: 'Live banners',
          value: '${website.visibleBanners.length}',
          caption: 'On website',
          icon: Icons.view_carousel_outlined,
          tone: AdminChipTone.success,
        ),
        AdminStatMetric(
          label: 'Visible FAQs',
          value: '$visibleFaqs',
          caption: 'Published',
          icon: Icons.help_outline,
          tone: AdminChipTone.info,
        ),
      ],
    );
  }
}

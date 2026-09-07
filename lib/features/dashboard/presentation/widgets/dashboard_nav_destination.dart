import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/router/route_names.dart';

class DashboardNavDestination {
  const DashboardNavDestination({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final IconData icon;

  static const List<DashboardNavDestination> all = [
    DashboardNavDestination(
      label: 'Dashboard',
      route: RouteNames.dashboard,
      icon: Icons.space_dashboard_outlined,
    ),
    DashboardNavDestination(
      label: 'Order Management',
      route: RouteNames.orders,
      icon: Icons.receipt_long_outlined,
    ),
    DashboardNavDestination(
      label: 'Print Queue',
      route: RouteNames.printQueue,
      icon: Icons.print_outlined,
    ),
    DashboardNavDestination(
      label: 'Product Management',
      route: RouteNames.products,
      icon: Icons.inventory_2_outlined,
    ),
    DashboardNavDestination(
      label: 'Categories',
      route: RouteNames.categories,
      icon: Icons.category_outlined,
    ),
    DashboardNavDestination(
      label: 'Inventory',
      route: RouteNames.inventory,
      icon: Icons.warehouse_outlined,
    ),
    DashboardNavDestination(
      label: 'Customers',
      route: RouteNames.customers,
      icon: Icons.people_outlined,
    ),
    DashboardNavDestination(
      label: 'Payments',
      route: RouteNames.payments,
      icon: Icons.payments_outlined,
    ),
    DashboardNavDestination(
      label: 'Shipping',
      route: RouteNames.shipping,
      icon: Icons.local_shipping_outlined,
    ),
    DashboardNavDestination(
      label: 'Website',
      route: RouteNames.website,
      icon: Icons.language_outlined,
    ),
    DashboardNavDestination(
      label: 'Analytics',
      route: RouteNames.analytics,
      icon: Icons.insights_outlined,
    ),
    DashboardNavDestination(
      label: 'User Management',
      route: RouteNames.users,
      icon: Icons.group_outlined,
    ),
    DashboardNavDestination(
      label: 'Settings',
      route: RouteNames.settings,
      icon: Icons.settings_outlined,
    ),
  ];

  static DashboardNavDestination byRoute(String route) {
    return all.firstWhere(
      (item) => item.route == route,
      orElse: () => all.first,
    );
  }

  String get pathSegment {
    return route.replaceFirst('${RouteNames.dashboard}/', '');
  }
}

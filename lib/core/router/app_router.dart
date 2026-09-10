import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:primelayer_admin_panel/core/router/go_router_refresh_stream.dart';
import 'package:primelayer_admin_panel/core/router/route_names.dart';
import 'package:primelayer_admin_panel/features/analytics/presentation/pages/analytics_page.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/pages/sign_in_page.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/pages/categories_page.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/pages/customers_page.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/pages/dashboard_overview_page.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_nav_destination.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/section_placeholder.dart';
import 'package:primelayer_admin_panel/features/inventory/presentation/pages/inventory_page.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/pages/orders_page.dart';
import 'package:primelayer_admin_panel/features/payments/presentation/pages/payments_page.dart';
import 'package:primelayer_admin_panel/features/print_queue/presentation/pages/print_queue_page.dart';
import 'package:primelayer_admin_panel/features/products/presentation/pages/products_page.dart';
import 'package:primelayer_admin_panel/features/profile/presentation/pages/profile_settings_page.dart';
import 'package:primelayer_admin_panel/features/settings/presentation/pages/settings_page.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/pages/shipping_page.dart';
import 'package:primelayer_admin_panel/features/users/presentation/pages/users_page.dart';
import 'package:primelayer_admin_panel/features/website/presentation/pages/website_page.dart';

abstract final class AppRouter {
  static GoRouter create(AuthCubit authCubit) {
    final rootNavigatorKey = GlobalKey<NavigatorState>();

    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: authCubit.state.isSignedIn
          ? RouteNames.dashboard
          : RouteNames.signIn,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        authCubit.revalidate();
        final signedIn = authCubit.state.isSignedIn;
        final onSignIn = state.matchedLocation == RouteNames.signIn;
        if (!signedIn) {
          return onSignIn ? null : RouteNames.signIn;
        }
        if (onSignIn) return RouteNames.dashboard;
        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.signIn,
          name: 'signIn',
          onExit: (context, state) => authCubit.state.isSignedIn,
          builder: (context, state) => const SignInPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => DashboardPage(child: child),
          routes: [
            GoRoute(
              path: RouteNames.dashboard,
              name: 'dashboard',
              builder: (context, state) => const DashboardOverviewPage(),
              routes: [
                for (final item in DashboardNavDestination.all)
                  if (item.route != RouteNames.dashboard)
                    GoRoute(
                      path: item.pathSegment,
                      name: item.pathSegment,
                      builder: (context, state) => _pageFor(item),
                    ),
                GoRoute(
                  path: 'profile-settings',
                  name: 'profileSettings',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const ProfileSettingsPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget _pageFor(DashboardNavDestination item) {
    return switch (item.route) {
      RouteNames.orders => const OrdersPage(),
      RouteNames.printQueue => const PrintQueuePage(),
      RouteNames.products => const ProductsPage(),
      RouteNames.categories => const CategoriesPage(),
      RouteNames.inventory => const InventoryPage(),
      RouteNames.customers => const CustomersPage(),
      RouteNames.payments => const PaymentsPage(),
      RouteNames.shipping => const ShippingPage(),
      RouteNames.website => const WebsitePage(),
      RouteNames.analytics => const AnalyticsPage(),
      RouteNames.users => const UsersPage(),
      RouteNames.settings => const SettingsPage(),
      _ => SectionPlaceholder(destination: item),
    };
  }
}

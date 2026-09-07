import 'package:go_router/go_router.dart';
import 'package:primelayer_admin_panel/core/router/go_router_refresh_stream.dart';
import 'package:primelayer_admin_panel/core/router/route_names.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/pages/sign_in_page.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:primelayer_admin_panel/features/profile/presentation/pages/profile_settings_page.dart';

abstract final class AppRouter {
  static GoRouter create(AuthCubit authCubit) {
    return GoRouter(
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
        GoRoute(
          path: RouteNames.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
          routes: [
            GoRoute(
              path: 'profile-settings',
              name: 'profileSettings',
              builder: (context, state) => const ProfileSettingsPage(),
            ),
          ],
        ),
      ],
    );
  }
}

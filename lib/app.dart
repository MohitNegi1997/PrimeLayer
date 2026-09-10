import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/theme/app_theme.dart';
import 'package:primelayer_admin_panel/core/theme/theme_cubit.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:primelayer_admin_panel/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:primelayer_admin_panel/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:primelayer_admin_panel/features/payments/presentation/cubit/payments_cubit.dart';
import 'package:primelayer_admin_panel/features/print_queue/presentation/cubit/print_queue_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:primelayer_admin_panel/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:primelayer_admin_panel/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:primelayer_admin_panel/features/splash/presentation/widgets/splash_host.dart';
import 'package:primelayer_admin_panel/features/users/presentation/cubit/users_cubit.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PrimeLayerAdminApp extends StatelessWidget {
  const PrimeLayerAdminApp({
    super.key,
    required this.authCubit,
    required this.router,
  });

  final AuthCubit authCubit;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => CategoriesCubit()),
        BlocProvider(create: (_) => ProductsCubit()),
        BlocProvider(create: (_) => CustomersCubit()),
        BlocProvider(create: (_) => OrdersCubit()),
        BlocProvider(create: (_) => PaymentsCubit()),
        BlocProvider(create: (_) => ShippingCubit()),
        BlocProvider(create: (_) => PrintQueueCubit()),
        BlocProvider(create: (_) => WebsiteCubit()),
        BlocProvider(create: (_) => UsersCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: router,
            builder: (context, child) {
              return ResponsiveBreakpoints.builder(
                child: SplashHost(child: child ?? const SizedBox.shrink()),
                breakpoints: const [
                  Breakpoint(start: 0, end: 450, name: MOBILE),
                  Breakpoint(start: 451, end: 800, name: TABLET),
                  Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

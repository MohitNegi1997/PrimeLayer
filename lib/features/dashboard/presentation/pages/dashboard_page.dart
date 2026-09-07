import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/theme/theme_cubit.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/app_logo.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_side_panel.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/profile_menu_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: isMobile,
          toolbarHeight: isDesktop ? 80 : 72,
          titleSpacing: isMobile ? 0 : 16,
          title: Row(
            children: [
              AppLogo(size: isDesktop ? 64 : 52),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  AppConstants.studioName,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.appBarTheme.foregroundColor,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Toggle theme',
              onPressed: () => context.read<ThemeCubit>().toggle(),
              icon: Icon(
                theme.brightness == Brightness.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
            const ProfileMenuButton(),
            const SizedBox(width: 8),
          ],
        ),
        drawer: isMobile ? const Drawer(child: DashboardSidePanel()) : null,
        body: Row(
          children: [
            if (!isMobile) ...[
              const SizedBox(width: 260, child: DashboardSidePanel()),
              VerticalDivider(width: 1, color: theme.dividerColor),
            ],
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

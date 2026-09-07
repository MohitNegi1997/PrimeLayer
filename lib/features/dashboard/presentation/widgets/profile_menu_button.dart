import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primelayer_admin_panel/core/router/route_names.dart';
import 'package:primelayer_admin_panel/core/theme/app_colors.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/auth/data/admin_credentials.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';

class ProfileMenuButton extends StatelessWidget {
  const ProfileMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final foreground = theme.appBarTheme.foregroundColor;

    return PopupMenuButton<String>(
      tooltip: 'Account',
      offset: const Offset(0, 48),
      onSelected: (value) async {
        if (value == 'profile') {
          context.push(RouteNames.profileSettings);
          return;
        }
        if (value == 'logout') {
          await context.read<AuthCubit>().signOut();
          if (context.mounted) {
            context.replace(RouteNames.signIn);
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(value: 'profile', child: Text('Profile Setting')),
        PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: isMobile ? 16 : 18,
              backgroundColor: AppColors.accent,
              child: Text(
                AdminCredentials.initials,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isMobile ? 140 : 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AdminCredentials.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: foreground,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    AdminCredentials.email,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: foreground),
          ],
        ),
      ),
    );
  }
}

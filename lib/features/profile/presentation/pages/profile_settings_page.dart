import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/theme/app_colors.dart';
import 'package:primelayer_admin_panel/features/auth/data/admin_credentials.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setting')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.accent,
                child: Text(
                  AdminCredentials.initials,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AdminCredentials.displayName,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(AdminCredentials.email, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

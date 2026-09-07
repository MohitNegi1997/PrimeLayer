import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/app_loader.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/widgets/dash_background.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const DashBackground(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLoader(size: isMobile ? 140 : 180),
                const SizedBox(height: 24),
                Text(
                  AppConstants.studioName,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(letterSpacing: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

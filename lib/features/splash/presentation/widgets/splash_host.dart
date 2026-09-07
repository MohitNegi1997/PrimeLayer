import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:primelayer_admin_panel/features/splash/presentation/pages/splash_page.dart';

class SplashHost extends StatelessWidget {
  const SplashHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, bool>(
      builder: (context, isDone) {
        return Stack(children: [child, if (!isDone) const SplashPage()]);
      },
    );
  }
}

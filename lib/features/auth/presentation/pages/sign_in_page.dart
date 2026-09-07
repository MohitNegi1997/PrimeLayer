import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primelayer_admin_panel/core/router/route_names.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/sign_in_state.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/widgets/dash_background.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/widgets/sign_in_card.dart';
import 'package:primelayer_admin_panel/features/splash/presentation/pages/splash_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(context.read<AuthCubit>()),
      child: BlocListener<SignInCubit, SignInState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == SignInStatus.success) {
            context.go(RouteNames.dashboard);
          }
        },
        child: BlocBuilder<SignInCubit, SignInState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return PopScope(
              canPop: false,
              child: Stack(
                children: [
                  const Scaffold(
                    body: Stack(
                      children: [
                        DashBackground(),
                        SafeArea(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(24),
                              child: SignInCard(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.status == SignInStatus.submitting)
                    const SplashPage(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

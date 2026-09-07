import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/constants/app_constants.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/app_logo.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/cubit/sign_in_state.dart';

class SignInCard extends StatelessWidget {
  const SignInCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isMobile ? 400 : 440),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 36,
            vertical: isMobile ? 32 : 40,
          ),
          child: BlocBuilder<SignInCubit, SignInState>(
            buildWhen: (previous, current) =>
                previous.isPasswordObscured != current.isPasswordObscured ||
                previous.status != current.status ||
                previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppLogo(size: isMobile ? 88 : 200),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.studioName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    onChanged: context.read<SignInCubit>().emailChanged,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: state.isPasswordObscured,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onChanged: context.read<SignInCubit>().passwordChanged,
                    onSubmitted: (_) => context.read<SignInCubit>().signIn(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: state.isPasswordObscured
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: context
                            .read<SignInCubit>()
                            .togglePasswordVisibility,
                        icon: Icon(
                          state.isPasswordObscured
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.read<SignInCubit>().signIn(),
                      child: const Text('Sign in'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

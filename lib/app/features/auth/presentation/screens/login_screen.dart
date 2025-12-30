import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:trip_planner/app/features/auth/presentation/wisgets/logo_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/app_text_fields.dart';
import '../providers/auth_providers.dart';

/// Login screen - Pure Riverpod with ConsumerWidget using Controllers
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formControllers = ref.watch(loginFormControllersProvider);
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.isLoading;

    // Listen for session changes (auth success)
    ref.listen<SessionState>(sessionProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.navigateAndClearStack(context, AppRoutes.home);
      }
    });

    // Listen for login error
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(loginProvider.notifier).clearError();
      }
    });

    void onLogin() {
      if (formControllers.validate(_formKey.currentState)) {
        ref
            .read(loginProvider.notifier)
            .login(
              email: formControllers.email,
              password: formControllers.password,
            );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(24),
                const LogoWidget(),
                const Gap(40),
                // Title
                Text(
                  'Welcome to ${AppStrings.appName}',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),

                // Subtitle
                Text(
                  'Log in to your existing account of ${AppStrings.appName}',
                  style: AppTextStyles.bodyMedium.copyWith(),
                  textAlign: TextAlign.center,
                ),
                const Gap(48),

                // Email field
                AppEmailField(
                  hintText: 'Zia@gmail.com',
                  validator: Validators.email,
                  textInputAction: TextInputAction.next,
                  controller: formControllers.emailController,
                ),
                const Gap(16),

                // Password field
                AppPasswordField(
                  hintText: '••••••',
                  validator: (value) => Validators.password(value),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onLogin(),
                  controller: formControllers.passwordController,
                ),
                const Gap(8),

                // Forgot password - aligned right
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      AppRoutes.navigateTo(context, AppRoutes.forgotPassword);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password ?',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Gap(32),

                // Log In button
                AppPrimaryButton(
                  text: 'Log In',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : onLogin,
                ),
                const Gap(16),

                // Sign Up button
                AppSecondaryButton(
                  text: 'Sign Up',
                  borderColor: AppColors.textPrimary,
                  textColor: AppColors.textPrimary,
                  onPressed: () {
                    AppRoutes.navigateTo(context, AppRoutes.signup);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
import '../providers/signup_providers.dart';

/// Signup screen - Pure Riverpod with ConsumerWidget using Controllers
class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formControllers = ref.watch(signupFormControllersProvider);
    final agreedToTerms = ref.watch(signupTermsAgreedProvider);
    final signupState = ref.watch(signupProvider);
    final isLoading = signupState.isLoading;

    // Listen for session changes (auth success)
    ref.listen<SessionState>(sessionProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Navigate to Verify Code instead of Home directly
        AppRoutes.navigateAndClearStack(context, AppRoutes.verifyCode);
      }
    });

    // Listen for signup error
    ref.listen<SignupState>(signupProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(signupProvider.notifier).clearError();
      }
    });

    void onSignup() {
      if (formControllers.validate()) {
        if (!agreedToTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please agree to the Terms and Conditions'),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
        ref.read(signupProvider.notifier).signup(
              email: formControllers.email,
              password: formControllers.password,
              fullName: '',
            );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formControllers.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                    const Gap(24),
                const LogoWidget(),
                const Gap(40),

                // Title
                Text(
                  'Let\'s Get Started!',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),

                // Subtitle
                Text(
                  'Create an account to ${AppStrings.appName}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
                  validator: (value) => Validators.strongPassword(value),
                  textInputAction: TextInputAction.next,
                  controller: formControllers.passwordController,
                ),
                const Gap(16),

                // Confirm password field
                AppPasswordField(
                  hintText: '••••••',
                  validator: (value) => Validators.confirmPassword(
                    value,
                    formControllers.password,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onSignup(),
                  controller: formControllers.confirmPasswordController,
                ),
                const Gap(16),

                // Terms and conditions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: agreedToTerms,
                        onChanged: (value) {
                          ref.read(signupTermsAgreedProvider.notifier).state = value ?? false;
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'I agree to ${AppStrings.appName} Terms And Conditions and acknowledge the Privacy Policy.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(32),

                // Create button
                AppPrimaryButton(
                  text: 'Create',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : onSignup,
                ),
                const Gap(16),

                // Log In button
                AppSecondaryButton(
                  text: 'Log In',
                  borderColor: AppColors.textPrimary,
                  textColor: AppColors.textPrimary,
                  onPressed: () {
                    AppRoutes.navigateAndReplace(context, AppRoutes.login);
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

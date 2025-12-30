import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/app_text_fields.dart';
import '../providers/password_recovery_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controllers = ref.watch(resetPasswordControllersProvider);
    final state = ref.watch(resetPasswordProvider);

    ref.listen<ResetPasswordState>(resetPasswordProvider, (previous, next) {
      if (next.isSuccess) {
        // Navigate to Login or Success Screen
        // Assuming Login for now as per minimal flow
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully'),
            backgroundColor: Colors.green,
          ),
        );
        AppRoutes.navigateAndClearStack(context, AppRoutes.login);
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    void onResetPassword() {
      if (!controllers.validate(_formKey.currentState)) return;
      if (controllers.newPassword != controllers.confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      ref.read(resetPasswordProvider.notifier).resetPassword(controllers.newPassword);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(100),
                Center(
                  child: Text(
                    'Create a new password',
                    style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(8),
                Center(
                  child: Text(
                    'Your new password must be different form\npreviously used password',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(

                    ),
                  ),
                ),
                const Gap(40),

                // New Password
                AppPasswordField(
                  controller: controllers.newPasswordController,
                  hintText: '******',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const Gap(24),

                // Confirm Password
                AppPasswordField(
                  controller: controllers.confirmPasswordController,
                  hintText: '******',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    return null;
                  },
                ),
                const Gap(24),

                // Reset Button
                AppPrimaryButton(
                  text: 'Reset Password',
                  onPressed: state.isLoading ? null : onResetPassword,
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

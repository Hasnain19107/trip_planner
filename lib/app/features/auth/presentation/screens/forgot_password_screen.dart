import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/app_text_fields.dart';
import '../providers/password_recovery_providers.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(forgotPasswordControllersProvider);
    final state = ref.watch(forgotPasswordProvider);

    ref.listen<ForgotPasswordState>(forgotPasswordProvider, (previous, next) {
      if (next.isSuccess) {
        AppRoutes.navigateTo(context, AppRoutes.forgotOrp);
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    void onSendCode() {
      if (!controllers.formKey.currentState!.validate()) return;
      ref.read(forgotPasswordProvider.notifier).sendCode(controllers.emailController.text.trim());
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
            key: controllers.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(100),
                Center(
                  child: Text(
                    'Forgot Password ?',
                    style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const Gap(8),
                Center(
                  child: Text(
                    'Enter your Email, we will send you a verification\ncode',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const Gap(40),
                
                // Email Field
                AppEmailField(
                  controller: controllers.emailController,
                  hintText: 'Enter your email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const Gap(24),
                
                // Send Code Button
                AppPrimaryButton(
                  text: 'Send Code',
                  onPressed: state.isLoading ? null : onSendCode,
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

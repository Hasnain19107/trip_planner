import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

import '../../../../core/constants/app_text_styles.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/otp_input_widget.dart';
import '../providers/signup_providers.dart';

import '../wisgets/logo_widget.dart';

class VerifyCodeScreen extends ConsumerWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controllers provider
    final formControllers = ref.watch(verifyCodeControllersProvider);
    final otpState = ref.watch(otpProvider);
    final isLoading = otpState.isLoading;

    // Listen for OTP verification success/error
    ref.listen<OtpState>(otpProvider, (previous, next) {
      if (next.isVerified) {
        // Navigate to Lets Get Started
        AppRoutes.navigateAndClearStack(context, AppRoutes.letsGetStarted);
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(otpProvider.notifier).clear();
      }
    });

    void onVerify() {
      if (!formControllers.isComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter the full code'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      ref.read(otpProvider.notifier).verifyOtp(formControllers.code);
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
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(24),
              // Logo
               const Center(child: LogoWidget()),

              const Gap(40),

              Center(
                child: Text(
                  'Verify Code',
                  style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(8),
              Center(
                child: Text(
                  'Enter the the code\nwe just sent you on your registered Email',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Gap(32),

              // OTP Input using controllers from provider
              OtpInputWidget(
                length: 5,
                controllers: formControllers.controllers,
                focusNodes: formControllers.focusNodes,
                onCompleted: (code) {
                   // Optional: Auto-verify on completion
                   // onVerify(); 
                },
              ),
              const Gap(40),

              // Verify Button
              AppPrimaryButton(
                text: 'Verify',
                onPressed: isLoading ? null : onVerify,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/otp_input_widget.dart';
import '../providers/password_recovery_providers.dart';

class ForgotOrpScreen extends ConsumerWidget {
  const ForgotOrpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controllers provider
    final formControllers = ref.watch(forgotOrpControllersProvider);
    final otpState = ref.watch(forgotOrpProvider);
    final isLoading = otpState.isLoading;

    // Listen for OTP verification success/error
    ref.listen<ForgotOrpState>(forgotOrpProvider, (previous, next) {
      if (next.isVerified) {
        // Navigate to Reset Password
        AppRoutes.navigateTo(context, AppRoutes.resetPassword);
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
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
      
      ref.read(forgotOrpProvider.notifier).verifyOtp(formControllers.code);
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
              const Gap(100),

              Center(
                child: Text(
                  'Verify Code',
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(8),
              Center(
                child: Text(
                  'Enter the the code\nwe just sent you on your registered Email',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                  
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

import '../../../../core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../providers/auth_providers.dart';

/// Splash screen displayed while the app initializes - Pure Riverpod
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize app after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp(context, ref);
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                );
              },
              child: Image.asset(AppImages.splashLogo, fit: BoxFit.contain),
            ),
            const SizedBox(height: 32),

            // App Name with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Text(
                AppStrings.appName,
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Tagline
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Text(
                'Plan your perfect adventure',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
            const SizedBox(height: 80),

            // Loading indicator
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeApp(BuildContext context, WidgetRef ref) async {
    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    // Check auth status
    await ref.read(sessionProvider.notifier).checkAuthStatus();

    // Auth status is now updated in provider
    final sessionState = ref.read(sessionProvider);

    if (context.mounted) {
      if (sessionState.status == AuthStatus.authenticated) {
        AppRoutes.navigateAndClearStack(context, AppRoutes.home);
      } else {
        AppRoutes.navigateAndClearStack(context, AppRoutes.login);
      }
    }
  }
}

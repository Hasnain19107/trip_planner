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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full screen splash image
          Image.asset(
            AppImages.splashScreen,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Loading indicator overlay
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
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
       // AppRoutes.navigateAndClearStack(context, AppRoutes.login);
      }
    }
  }
}

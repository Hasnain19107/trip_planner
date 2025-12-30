import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/forgot_orp_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/lets_get_started_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verify_code_screen.dart';

/// Application route names and navigation configuration
class AppRoutes {
  AppRoutes._();

  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyCode = '/verify-code';
  static const String letsGetStarted = '/lets-get-started';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String tripDetails = '/trip-details';
  static const String createTrip = '/create-trip';
  static const String editTrip = '/edit-trip';
  static const String explore = '/explore';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String forgotOrp = '/forgot-orp';

  /// Generate route based on settings
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(
          const SplashScreen(),
          settings,
        );

      case onboarding:
        // TODO: Return OnboardingScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Onboarding'))),
          settings,
        );

      case login:
        return _buildRoute(
          const LoginScreen(),
          settings,
        );

      case signup:
        return _buildRoute(
          const SignupScreen(),
          settings,
        );

      case forgotOrp:
        return _buildRoute(
          const ForgotOrpScreen(),
          settings,
        );

      case verifyCode:
        return MaterialPageRoute(builder: (_) => const VerifyCodeScreen());

      case letsGetStarted: // Added new case
        return MaterialPageRoute(builder: (_) => const LetsGetStartedScreen());
            
      case forgotPassword:
        return _buildRoute(
          const ForgotPasswordScreen(),
          settings,
        );

      case resetPassword:
        return _buildRoute(
          const ResetPasswordScreen(),
          settings,
        );
            
      case home:
        // TODO: Return HomeScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Home'))),
          settings,
        );

      case tripDetails:
        // TODO: Return TripDetailsScreen with arguments
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Trip Details'))),
          settings,
        );

      case createTrip:
        // TODO: Return CreateTripScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Create Trip'))),
          settings,
        );

      case editTrip:
        // TODO: Return EditTripScreen with arguments
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Edit Trip'))),
          settings,
        );

      case explore:
        // TODO: Return ExploreScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Explore'))),
          settings,
        );

      case favorites:
        // TODO: Return FavoritesScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Favorites'))),
          settings,
        );

      case profile:
        // TODO: Return ProfileScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Profile'))),
          settings,
        );

      case editProfile:
        // TODO: Return EditProfileScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Edit Profile'))),
          settings,
        );

      case AppRoutes.settings:
        // TODO: Return SettingsScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Settings'))),
          settings,
        );

      case notifications:
        // TODO: Return NotificationsScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Notifications'))),
          settings,
        );

      case search:
        // TODO: Return SearchScreen
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Search'))),
          settings,
        );

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  /// Build a MaterialPageRoute with the given widget
  static MaterialPageRoute<dynamic> _buildRoute(
    Widget widget,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => widget,
      settings: settings,
    );
  }

  /// Navigate to a named route
  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Navigate to a named route and replace the current route
  static Future<T?> navigateAndReplace<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, dynamic>(context, routeName, arguments: arguments);
  }

  /// Navigate to a named route and clear all previous routes
  static Future<T?> navigateAndClearStack<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop the current route
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}

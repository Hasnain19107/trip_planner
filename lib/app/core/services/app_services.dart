import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Storage service for local data persistence
abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

/// Secure storage service for sensitive data
abstract class SecureStorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// Navigation service for programmatic navigation
abstract class NavigationService {
  Future<T?> navigateTo<T>(String routeName, {Object? arguments});
  Future<T?> navigateAndReplace<T>(String routeName, {Object? arguments});
  Future<T?> navigateAndClearStack<T>(String routeName, {Object? arguments});
  void pop<T>([T? result]);
  void popUntil(String routeName);
}

/// Shared preference keys
class StorageKeys {
  StorageKeys._();

  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String isFirstLaunch = 'is_first_launch';
  static const String isLoggedIn = 'is_logged_in';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String lastSyncTime = 'last_sync_time';
}

/// Permissions service for handling app permissions
class PermissionsService {
  /// Request location permission
  Future<bool> requestLocationPermission() async {
    // TODO: Implement using permission_handler package
    return true;
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    // TODO: Implement using permission_handler package
    return true;
  }

  /// Request storage permission
  Future<bool> requestStoragePermission() async {
    // TODO: Implement using permission_handler package
    return true;
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    // TODO: Implement using permission_handler package
    return true;
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    // TODO: Implement using permission_handler package
    return true;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    // TODO: Implement using permission_handler package
    return true;
  }
}

/// Haptic feedback service
class HapticService {
  /// Light impact haptic feedback
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact haptic feedback
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact haptic feedback
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click haptic feedback
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }
}

// ==================== Riverpod Providers ====================

/// Permissions service provider
final permissionsServiceProvider = Provider<PermissionsService>((ref) {
  return PermissionsService();
});

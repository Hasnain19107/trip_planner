import '../entities/user_entity.dart';

/// Abstract repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<AuthResult> signup({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });

  /// Logout current user
  Future<void> logout();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Refresh authentication token
  Future<AuthResult> refreshToken(String refreshToken);

  /// Get current authenticated user
  Future<UserEntity?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Update user profile
  Future<UserEntity> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  });

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete account
  Future<void> deleteAccount(String password);

  /// Verify email with token
  Future<void> verifyEmail(String token);

  /// Resend verification email
  Future<void> resendVerificationEmail();
}

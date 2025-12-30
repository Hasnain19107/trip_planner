import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResult> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}

/// Use case for user signup
class SignupUseCase {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  Future<AuthResult> call({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) {
    return _repository.signup(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }
}

/// Use case for user logout
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call() {
    return _repository.logout();
  }
}

/// Use case to send password reset email
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<void> call(String email) {
    return _repository.sendPasswordResetEmail(email);
  }
}

/// Use case to reset password
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> call({
    required String token,
    required String newPassword,
  }) {
    return _repository.resetPassword(token: token, newPassword: newPassword);
  }
}

/// Use case to get current user
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<UserEntity?> call() {
    return _repository.getCurrentUser();
  }
}

/// Use case to check authentication status
class IsAuthenticatedUseCase {
  final AuthRepository _repository;

  IsAuthenticatedUseCase(this._repository);

  Future<bool> call() {
    return _repository.isAuthenticated();
  }
}

/// Use case to update user profile
class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UserEntity> call({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return _repository.updateProfile(
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
  }
}

/// Use case to change password
class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) {
    return _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}

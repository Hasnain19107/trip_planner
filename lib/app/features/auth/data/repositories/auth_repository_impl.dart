import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

/// Implementation of AuthRepository using remote data source
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  
  // TODO: Add local storage for token caching
  String? _cachedToken;
  UserEntity? _cachedUser;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    
    _cachedToken = response.accessToken;
    _cachedUser = response.user?.toEntity();
    
    // TODO: Store token in secure storage
    
    return response.toEntity();
  }

  @override
  Future<AuthResult> signup({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await _remoteDataSource.signup(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
    
    _cachedToken = response.accessToken;
    _cachedUser = response.user?.toEntity();
    
    // TODO: Store token in secure storage
    
    return response.toEntity();
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } finally {
      _cachedToken = null;
      _cachedUser = null;
      // TODO: Clear token from secure storage
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _remoteDataSource.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    final response = await _remoteDataSource.refreshToken(refreshToken);
    
    _cachedToken = response.accessToken;
    
    // TODO: Update token in secure storage
    
    return response.toEntity();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    if (_cachedUser != null) {
      return _cachedUser;
    }
    
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      _cachedUser = userModel.toEntity();
      return _cachedUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    // TODO: Check token from secure storage
    return _cachedToken != null;
  }

  @override
  Future<UserEntity> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final userModel = await _remoteDataSource.updateProfile(
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
    
    _cachedUser = userModel.toEntity();
    return _cachedUser!;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> deleteAccount(String password) async {
    await _remoteDataSource.deleteAccount(password);
    _cachedToken = null;
    _cachedUser = null;
    // TODO: Clear all stored data
  }

  @override
  Future<void> verifyEmail(String token) async {
    await _remoteDataSource.verifyEmail(token);
  }

  @override
  Future<void> resendVerificationEmail() async {
    await _remoteDataSource.resendVerificationEmail();
  }
}

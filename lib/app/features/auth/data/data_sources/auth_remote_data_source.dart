import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> signup({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<AuthResponseModel> refreshToken(String refreshToken);

  Future<UserModel> getCurrentUser();

  Future<UserModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount(String password);

  Future<void> verifyEmail(String token);

  Future<void> resendVerificationEmail();
}

/// Implementation of remote data source using Dio
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> signup({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await _dioClient.post(
      '/auth/signup',
      data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
      },
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _dioClient.post('/auth/logout');
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _dioClient.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _dioClient.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _dioClient.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _dioClient.get('/auth/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final response = await _dioClient.patch(
      '/auth/profile',
      data: {
        if (fullName != null) 'full_name': fullName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      },
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dioClient.post(
      '/auth/change-password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  @override
  Future<void> deleteAccount(String password) async {
    await _dioClient.delete(
      '/auth/account',
      data: {'password': password},
    );
  }

  @override
  Future<void> verifyEmail(String token) async {
    await _dioClient.post(
      '/auth/verify-email',
      data: {'token': token},
    );
  }

  @override
  Future<void> resendVerificationEmail() async {
    await _dioClient.post('/auth/resend-verification');
  }
}

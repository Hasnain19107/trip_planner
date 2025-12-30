import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';


final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: 'https://api.example.com/v1', 
  );
});



/// Auth remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSourceImpl(dioClient);
});



/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});



/// Login use case provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

/// Signup use case provider
final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
});

/// Logout use case provider
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

/// Forgot password use case provider
final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
});

/// Get current user use case provider
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

/// Is authenticated use case provider
final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>((ref) {
  return IsAuthenticatedUseCase(ref.watch(authRepositoryProvider));
});



/// Auth state enumeration
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Session state (global auth status)
class SessionState {
  final AuthStatus status;
  final UserEntity? user;
  
  const SessionState({
    this.status = AuthStatus.initial,
    this.user,
  });
}

/// Session Notifier (manages current user & authentication check)
class SessionNotifier extends StateNotifier<SessionState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsAuthenticatedUseCase _isAuthenticatedUseCase;
  final LogoutUseCase _logoutUseCase;

  SessionNotifier({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required IsAuthenticatedUseCase isAuthenticatedUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase,
        _isAuthenticatedUseCase = isAuthenticatedUseCase,
        _logoutUseCase = logoutUseCase,
        super(const SessionState());

  Future<void> checkAuthStatus() async {
    try {
      final isAuthenticated = await _isAuthenticatedUseCase();
      if (isAuthenticated) {
        final user = await _getCurrentUserUseCase();
        state = SessionState(
          status: AuthStatus.authenticated,
          user: user,
        );
      } else {
        state = const SessionState(status: AuthStatus.unauthenticated);
      }
    } catch (_) {
      state = const SessionState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    state = const SessionState(status: AuthStatus.unauthenticated);
  }
  
  // Called by other providers when login/signup succeeds
  void setAuthenticated(UserEntity user) {
    state = SessionState(status: AuthStatus.authenticated, user: user);
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    isAuthenticatedUseCase: ref.watch(isAuthenticatedUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
  );
});

// --- Login Provider ---

class LoginState {
  final bool isLoading;
  final String? error;
  
  const LoginState({this.isLoading = false, this.error});
}

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase; // Kept for DI structure but unused
  final SessionNotifier _sessionNotifier;

  LoginNotifier(this._loginUseCase, this._sessionNotifier) : super(const LoginState());

  Future<void> login({required String email, required String password}) async {
    state = const LoginState(isLoading: true);
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock success
      final mockUser = UserEntity(
        id: '1', 
        email: email, 
        fullName: 'Test User',
      );
      _sessionNotifier.setAuthenticated(mockUser);
      state = const LoginState(isLoading: false);
    } catch (e) {
      state = LoginState(isLoading: false, error: e.toString());
    }
  }
  
  void clearError() => state = const LoginState();
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(
    ref.watch(loginUseCaseProvider),
    ref.read(sessionProvider.notifier),
  );
});

// --- Signup Provider ---
// Moved to signup_providers.dart

// --- OTP Provider ---
// Moved to signup_providers.dart

// Convenience Providers for backward compatibility or simple access
final currentUserProvider = Provider<UserEntity?>((ref) => ref.watch(sessionProvider).user);
final isAuthenticatedProvider = Provider<bool>((ref) => ref.watch(sessionProvider).status == AuthStatus.authenticated);



// ==================== Form Controller Providers ====================



/// Login form controllers
class LoginFormControllers {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  LoginFormControllers()
      : emailController = TextEditingController(),
        passwordController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  String get email => emailController.text.trim();
  String get password => passwordController.text;

  bool validate() => formKey.currentState?.validate() ?? false;
}

/// Login form controllers provider (autodispose)
final loginFormControllersProvider = Provider.autoDispose<LoginFormControllers>((ref) {
  final controllers = LoginFormControllers();
  ref.onDispose(() {
    controllers.dispose();
  });
  return controllers;
});

// Other form controllers moved to signup_providers.dart


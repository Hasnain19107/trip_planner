import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_providers.dart';

// ==================== Signup & Verification Providers ====================

// --- Signup Provider ---

class SignupState {
  final bool isLoading;
  final String? error;

  const SignupState({this.isLoading = false, this.error});
}

class SignupNotifier extends StateNotifier<SignupState> {
  final SignupUseCase _signupUseCase; // Kept for DI structure but unused in mock
  final SessionNotifier _sessionNotifier;

  SignupNotifier(this._signupUseCase, this._sessionNotifier) : super(const SignupState());

  Future<void> signup({
    required String email, 
    required String password, 
    required String fullName,
    String? phoneNumber,
  }) async {
    state = const SignupState(isLoading: true);
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock success
      final mockUser = UserEntity(
        id: '2', 
        email: email, 
        fullName: fullName.isEmpty ? 'New User' : fullName,
        phoneNumber: phoneNumber,
      );
      _sessionNotifier.setAuthenticated(mockUser);
      state = const SignupState(isLoading: false);
    } catch (e) {
      state = SignupState(isLoading: false, error: e.toString());
    }
  }
  
  void clearError() => state = const SignupState();
}

final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((ref) {
  return SignupNotifier(
    ref.watch(signupUseCaseProvider),
    ref.read(sessionProvider.notifier),
  );
});

// --- OTP Provider (Verification) ---

class OtpState {
  final bool isLoading;
  final String? error;
  final bool isVerified;

  const OtpState({this.isLoading = false, this.error, this.isVerified = false});
}

class OtpNotifier extends StateNotifier<OtpState> {
  OtpNotifier() : super(const OtpState());

  Future<void> verifyOtp(String code) async {
    state = const OtpState(isLoading: true);
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock success (verification only)
      state = const OtpState(isLoading: false, isVerified: true);
    } catch (e) {
      state = OtpState(isLoading: false, error: e.toString());
    }
  }

  void clear() => state = const OtpState();
}

final otpProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  return OtpNotifier();
});

// --- Form Controllers ---

/// Signup form controllers
class SignupFormControllers {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  bool agreedToTerms = false;

  SignupFormControllers()
      : emailController = TextEditingController(),
        passwordController = TextEditingController(),
        confirmPasswordController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    agreedToTerms = false;
  }

  String get email => emailController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  bool validate() => formKey.currentState?.validate() ?? false;
}

/// Signup form controllers provider (autodispose)
final signupFormControllersProvider = Provider.autoDispose<SignupFormControllers>((ref) {
  final controllers = SignupFormControllers();
  ref.onDispose(() {
    controllers.dispose();
  });
  return controllers;
});

/// Signup terms agreement state provider
final signupTermsAgreedProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Verify Code form controllers
class VerifyCodeControllers {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int length;

  VerifyCodeControllers({this.length = 5})
      : controllers = List.generate(length, (_) => TextEditingController()),
        focusNodes = List.generate(length, (_) => FocusNode());

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
  }

  void clear() {
    for (var controller in controllers) {
      controller.clear();
    }
    // Requests focus on the first field
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }

  String get code => controllers.map((c) => c.text).join();
  bool get isComplete => code.length == length;
}

/// Verify Code form controllers provider (autodispose)
final verifyCodeControllersProvider = Provider.autoDispose<VerifyCodeControllers>((ref) {
  final controllers = VerifyCodeControllers();
  ref.onDispose(() {
    controllers.dispose();
  });
  return controllers;
});

/// Lets Get Started form controllers
class LetsGetStartedControllers {
  final TextEditingController nameController;
  final TextEditingController dobController;
  final TextEditingController countryController;
  final TextEditingController genderController;
  final TextEditingController languageController;
  final GlobalKey<FormState> formKey;

  LetsGetStartedControllers()
      : nameController = TextEditingController(),
        dobController = TextEditingController(),
        countryController = TextEditingController(),
        genderController = TextEditingController(),
        languageController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    nameController.dispose();
    dobController.dispose();
    countryController.dispose();
    genderController.dispose();
    languageController.dispose();
  }

  void clear() {
    nameController.clear();
    dobController.clear();
    countryController.clear();
    genderController.clear();
    languageController.clear();
  }
  
  bool validate() => formKey.currentState?.validate() ?? false;
}

/// Lets Get Started form controllers provider (autodispose)
final letsGetStartedControllersProvider = Provider.autoDispose<LetsGetStartedControllers>((ref) {
  final controllers = LetsGetStartedControllers();
  ref.onDispose(() {
    controllers.dispose();
  });
  return controllers;
});

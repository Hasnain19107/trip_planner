import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== Password Recovery Providers ====================

// --- Forgot Password Screen Providers ---

class ForgotPasswordControllers {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  ForgotPasswordControllers()
      : emailController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
  }

  void clear() {
    emailController.clear();
  }
}

final forgotPasswordControllersProvider = Provider.autoDispose<ForgotPasswordControllers>((ref) {
  final controllers = ForgotPasswordControllers();
  ref.onDispose(() {
    controllers.dispose();
  });
  return controllers;
});

class ForgotPasswordState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const ForgotPasswordState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier() : super(const ForgotPasswordState());

  Future<void> sendCode(String email) async {
    state = const ForgotPasswordState(isLoading: true);
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));
      state = const ForgotPasswordState(isLoading: false, isSuccess: true);
    } catch (e) {
      state = ForgotPasswordState(isLoading: false, error: e.toString());
    }
  }
}

final forgotPasswordProvider = StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  return ForgotPasswordNotifier();
});


// --- Forgot Password OTP Screen Providers ---

class ForgotOrpControllers {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int length;

  ForgotOrpControllers({this.length = 5})
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
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }

  String get code => controllers.map((c) => c.text).join();
  bool get isComplete => code.length == length;
}

final forgotOrpControllersProvider = Provider.autoDispose<ForgotOrpControllers>((ref) {
  final controllers = ForgotOrpControllers();
  ref.onDispose(() {
    controllers.dispose();
  });
  return controllers;
});

class ForgotOrpState {
  final bool isLoading;
  final String? error;
  final bool isVerified;

  const ForgotOrpState({
    this.isLoading = false,
    this.error,
    this.isVerified = false,
  });
}

class ForgotOrpNotifier extends StateNotifier<ForgotOrpState> {
  ForgotOrpNotifier() : super(const ForgotOrpState());

  Future<void> verifyOtp(String code) async {
    state = const ForgotOrpState(isLoading: true);
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));
      state = const ForgotOrpState(isLoading: false, isVerified: true);
    } catch (e) {
      state = ForgotOrpState(isLoading: false, error: e.toString());
    }
  }
}

final forgotOrpProvider = StateNotifierProvider<ForgotOrpNotifier, ForgotOrpState>((ref) {
  return ForgotOrpNotifier();
});


// --- Reset Password Screen Providers ---

class ResetPasswordControllers {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  ResetPasswordControllers()
      : newPasswordController = TextEditingController(),
        confirmPasswordController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  void clear() {
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  String get newPassword => newPasswordController.text;
  String get confirmPassword => confirmPasswordController.text;

  bool validate() => formKey.currentState?.validate() ?? false;
}

final resetPasswordControllersProvider = Provider.autoDispose<ResetPasswordControllers>((ref) {
  final controllers = ResetPasswordControllers();
  ref.onDispose(() {
    controllers.dispose();
  });
  return controllers;
});

class ResetPasswordState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const ResetPasswordState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier() : super(const ResetPasswordState());

  Future<void> resetPassword(String newPassword) async {
    state = const ResetPasswordState(isLoading: true);
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));
      
      state = const ResetPasswordState(isLoading: false, isSuccess: true);
    } catch (e) {
      state = ResetPasswordState(isLoading: false, error: e.toString());
    }
  }
}

final resetPasswordProvider = StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>((ref) {
  return ResetPasswordNotifier();
});

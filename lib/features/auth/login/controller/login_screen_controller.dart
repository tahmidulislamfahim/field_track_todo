import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:field_track_todo/features/auth/login/service/login_service.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:field_track_todo/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginScreenControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => LoginScreenController(),
);

class LoginScreenController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isPasswordVisible = false;
  bool isLoading = false;

  final LoginService _loginService = LoginService();

  LoginScreenController() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await _loginService.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.status.isOk) {
        final body = response.body;
        if (body != null && body is Map) {
          final accessToken = body['access_token'];
          final refreshToken = body['refresh_token'];

          if (accessToken != null && refreshToken != null) {
            await SharedPreferencesHelper.saveAccessToken(accessToken);
            await SharedPreferencesHelper.saveRefreshToken(refreshToken);

            EasyLoading.showSuccess('Signed in successfully!');

            NavigationService.clearStackAndShow(AppRoutes.navBarScreen);
          } else {
            EasyLoading.showError('Invalid response format from server.');
          }
        } else {
          EasyLoading.showError('Invalid response format from server.');
        }
      } else {
        String errorMsg = 'Authentication failed. Please try again.';
        if (response.body != null && response.body is Map) {
          errorMsg = response.body['message'] ?? errorMsg;
        }

        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      EasyLoading.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

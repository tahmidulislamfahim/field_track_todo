import 'package:field_track_todo/core/local_service/shared_preference_helper.dart';
import 'package:field_track_todo/features/auth/login/service/login_service.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final LoginService _loginService = Get.put(LoginService());

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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

    isLoading.value = true;

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

            Get.offAllNamed(AppRoutes.navBarScreen);
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
      isLoading.value = false;
    }
  }
}

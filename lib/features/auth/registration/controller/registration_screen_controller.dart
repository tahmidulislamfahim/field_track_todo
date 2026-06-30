import 'package:field_track_todo/core/local_service/shared_preference_helper.dart';
import 'package:field_track_todo/features/auth/registration/service/registration_service.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegistrationScreenController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final RegistrationService _registrationService = Get.put(
    RegistrationService(),
  );

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
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
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await _registrationService.registerUser(
        name: nameController.text.trim(),
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

            EasyLoading.showSuccess('Account created successfully!');

            Get.offAllNamed(AppRoutes.navBarScreen);
          } else {
            EasyLoading.showError('Invalid response format from server.');
          }
        } else {
          EasyLoading.showError('Invalid response format from server.');
        }
      } else {
        String errorMsg = 'Failed to register account. Please try again.';
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

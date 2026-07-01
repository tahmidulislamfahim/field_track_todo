import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:field_track_todo/features/auth/registration/service/registration_service.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:field_track_todo/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registrationScreenControllerProvider = ChangeNotifierProvider.autoDispose((ref) => RegistrationScreenController());

class RegistrationScreenController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isPasswordVisible = false;
  bool isLoading = false;

  final RegistrationService _registrationService = RegistrationService();

  RegistrationScreenController() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
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

    isLoading = true;
    notifyListeners();

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

            NavigationService.clearStackAndShow(AppRoutes.navBarScreen);
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
      isLoading = false;
      notifyListeners();
    }
  }
}

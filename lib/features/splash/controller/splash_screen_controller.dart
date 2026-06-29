// ignore_for_file: avoid_print

import 'package:field_track_todo/core/local_service/shared_preference_helper.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigationtoOnboarding();
  }

  void navigationtoOnboarding() {
    Timer(const Duration(seconds: 3), () async {
      final String? accessToken =
          await SharedPreferencesHelper.getAccessToken();
      final String? refreshToken =
          await SharedPreferencesHelper.getRefreshToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        try {
          print('accessToken: $accessToken');
          print('refreshToken: $refreshToken');

          Get.offAllNamed(AppRoutes.navBarScreen);
        } catch (e) {
          debugPrint('Error fetching profile on splash onboarding check: $e');
          Get.offAllNamed(AppRoutes.login);
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}

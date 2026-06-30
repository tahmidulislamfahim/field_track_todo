import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:field_track_todo/features/splash/service/splash_service.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashScreenController extends GetxController {
  final SplashService _splashService = Get.put(SplashService());

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

      if (accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty) {
        try {
          debugPrint('accessToken: $accessToken');
          debugPrint('refreshToken: $refreshToken');
          final response = await _splashService.checkMe(accessToken);

          if (response.status.isOk) {
            Get.offAllNamed(AppRoutes.navBarScreen);
          } else {
            debugPrint('AccessToken invalid or expired, trying refresh...');
            final refreshResponse = await _splashService.refreshAuthToken(
              refreshToken,
            );

            if (refreshResponse.status.isOk) {
              final body = refreshResponse.body;
              if (body != null && body is Map) {
                final newAccess = body['access_token'];
                final newRefresh = body['refresh_token'];

                if (newAccess != null && newRefresh != null) {
                  await SharedPreferencesHelper.saveAccessToken(newAccess);
                  await SharedPreferencesHelper.saveRefreshToken(newRefresh);

                  Get.offAllNamed(AppRoutes.navBarScreen);
                  return;
                }
              }
            }

            await SharedPreferencesHelper.clearAll();
            Get.offAllNamed(AppRoutes.login);
          }
        } catch (e) {
          debugPrint('Error fetching profile on splash onboarding check: $e');
          await SharedPreferencesHelper.clearAll();
          Get.offAllNamed(AppRoutes.login);
        }
      } else {
        await SharedPreferencesHelper.clearAll();
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}

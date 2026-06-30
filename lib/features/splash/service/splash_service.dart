import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashService extends GetConnect {
  Future<Response> checkMe(String token) async {
    debugPrint('GET URL: ${Endpoints.userMe}');

    final response = await get(
      Endpoints.userMe,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('BODY: ${response.bodyString}');

    return response;
  }

  Future<Response> refreshAuthToken(String refreshToken) async {
    final Map<String, dynamic> body = {
      'refresh_token': refreshToken,
    };

    debugPrint('POST URL: ${Endpoints.refresh}');
    debugPrint('PAYLOAD: $body');

    final response = await post(
      Endpoints.refresh,
      body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('BODY: ${response.bodyString}');

    return response;
  }
}

import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CreateLocationService extends GetConnect {
  Future<Response> createLocation({
    required String name,
    required double latitude,
    required double longitude,
    required double radiusM,
  }) async {
    final String? token = await SharedPreferencesHelper.getAccessToken();

    final Map<String, dynamic> body = {
      'location_name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius_m': radiusM.toInt(),
    };

    debugPrint('POST URL: ${Endpoints.locations}');
    debugPrint('PAYLOAD: $body');

    final response = await post(
      Endpoints.locations,
      body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('BODY: ${response.bodyString}');

    return response;
  }
}

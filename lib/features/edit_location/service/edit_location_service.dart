import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/local_service/shared_preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class EditLocationService extends GetConnect {
  Future<Response> deleteLocation(String locationId) async {
    final String? token = await SharedPreferencesHelper.getAccessToken();
    final url = Endpoints.deleteOrEditLocation(locationId);

    debugPrint('DELETE URL: $url');

    final response = await delete(
      url,
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

  Future<Response> updateLocation({
    required String locationId,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusM,
    required bool isActive,
  }) async {
    final String? token = await SharedPreferencesHelper.getAccessToken();
    final url = Endpoints.deleteOrEditLocation(locationId);

    final Map<String, dynamic> body = {
      'location_name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius_m': radiusM.toInt(),
      'is_active': isActive,
    };

    debugPrint('PUT URL: $url');
    debugPrint('PAYLOAD: $body');

    final response = await put(
      url,
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

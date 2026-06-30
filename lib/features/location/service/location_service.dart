import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/local_service/shared_preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LocationService extends GetConnect {
  Future<Response> fetchLocations() async {
    final String? token = await SharedPreferencesHelper.getAccessToken();

    debugPrint('GET URL: ${Endpoints.getAllLocations}');

    final response = await get(
      Endpoints.getAllLocations,
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

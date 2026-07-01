import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:field_track_todo/core/services/base_service.dart';
import 'package:flutter/foundation.dart';

class ProfileService extends BaseService {
  Future<Response> fetchProfile() async {
    final String? token = await SharedPreferencesHelper.getAccessToken();

    debugPrint('GET URL: ${Endpoints.userMe}');

    final response = await get(
      Endpoints.userMe,
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

  Future<Response> logoutUser() async {
    final String? token = await SharedPreferencesHelper.getAccessToken();

    debugPrint('POST URL: ${Endpoints.logout}');

    final response = await post(
      Endpoints.logout,
      '',
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

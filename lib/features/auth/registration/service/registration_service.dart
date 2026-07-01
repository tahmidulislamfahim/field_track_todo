import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/services/base_service.dart';
import 'package:flutter/foundation.dart';

class RegistrationService extends BaseService {
  Future<Response> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      'full_name': name,
      'email': email,
      'password': password,
    };

    debugPrint('POST URL: ${Endpoints.registration}');
    debugPrint('PAYLOAD: $body');

    final response = await post(
      Endpoints.registration,
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

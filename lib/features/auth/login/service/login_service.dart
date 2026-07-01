import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/services/base_service.dart';
import 'package:flutter/foundation.dart';

class LoginService extends BaseService {
  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    debugPrint('POST URL: ${Endpoints.login}');
    debugPrint('PAYLOAD: $body');

    final response = await post(
      Endpoints.login,
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

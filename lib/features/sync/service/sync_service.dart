import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SyncService extends GetConnect {
  Future<Response> syncTodos(List<Map<String, dynamic>> changes) async {
    final String? token = await SharedPreferencesHelper.getAccessToken();
    final String url = Endpoints.syncTodo;

    final Map<String, dynamic> body = {
      'changes': changes,
    };

    debugPrint('SYNC POST URL: $url');
    debugPrint('SYNC REQUEST BODY: $body');

    final response = await post(
      url,
      body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    debugPrint('SYNC STATUS CODE: ${response.statusCode}');
    debugPrint('SYNC RESPONSE BODY: ${response.bodyString}');

    return response;
  }
}

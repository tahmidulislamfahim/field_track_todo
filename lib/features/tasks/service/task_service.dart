import 'package:field_track_todo/core/endpoints/endpoints.dart';
import 'package:field_track_todo/core/services/shared_preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TaskService extends GetConnect {
  Future<Response> fetchTodos() async {
    final String? token = await SharedPreferencesHelper.getAccessToken();

    debugPrint('GET URL: ${Endpoints.getAllTodo}');

    final response = await get(
      Endpoints.getAllTodo,
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

  Future<Response> updateTodo({
    required String todoId,
    required bool isCompleted,
    required DateTime updatedAt,
  }) async {
    final String? token = await SharedPreferencesHelper.getAccessToken();
    final url = Endpoints.updateTodo(todoId);

    final Map<String, dynamic> body = {
      'is_completed': isCompleted,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };

    debugPrint('PATCH URL: $url');
    debugPrint('PAYLOAD: $body');

    final response = await patch(
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

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Response {
  final dynamic body;
  final String? bodyString;
  final int? statusCode;
  final ResponseStatus status;

  Response({
    this.body,
    this.bodyString,
    this.statusCode,
  }) : status = ResponseStatus(statusCode);
}

class ResponseStatus {
  final int? statusCode;
  ResponseStatus(this.statusCode);

  bool get isOk => statusCode != null && statusCode! >= 200 && statusCode! < 300;
  bool get connectionError => statusCode == null;
}

class BaseService {
  final http.Client _client = http.Client();

  Future<Response> get(String url, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client.get(uri, headers: headers);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('BaseService GET Error: $e');
      return Response(statusCode: null, body: {'message': e.toString()}, bodyString: e.toString());
    }
  }

  Future<Response> post(String url, dynamic body, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final encodedBody = body is String ? body : jsonEncode(body);
      final response = await _client.post(uri, body: encodedBody, headers: headers);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('BaseService POST Error: $e');
      return Response(statusCode: null, body: {'message': e.toString()}, bodyString: e.toString());
    }
  }

  Future<Response> put(String url, dynamic body, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final encodedBody = body is String ? body : jsonEncode(body);
      final response = await _client.put(uri, body: encodedBody, headers: headers);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('BaseService PUT Error: $e');
      return Response(statusCode: null, body: {'message': e.toString()}, bodyString: e.toString());
    }
  }

  Future<Response> patch(String url, dynamic body, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final encodedBody = body is String ? body : jsonEncode(body);
      final response = await _client.patch(uri, body: encodedBody, headers: headers);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('BaseService PATCH Error: $e');
      return Response(statusCode: null, body: {'message': e.toString()}, bodyString: e.toString());
    }
  }

  Future<Response> delete(String url, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client.delete(uri, headers: headers);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('BaseService DELETE Error: $e');
      return Response(statusCode: null, body: {'message': e.toString()}, bodyString: e.toString());
    }
  }

  Response _parseResponse(http.Response response) {
    dynamic body;
    try {
      if (response.body.isNotEmpty) {
        body = jsonDecode(response.body);
      }
    } catch (_) {
      body = response.body;
    }
    return Response(
      body: body,
      bodyString: response.body,
      statusCode: response.statusCode,
    );
  }
}

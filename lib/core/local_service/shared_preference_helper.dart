import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Clear all auth data
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
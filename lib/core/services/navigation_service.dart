import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic>? navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? replaceWith(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? clearStackAndShow(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void goBack() {
    navigatorKey.currentState?.pop();
  }
}

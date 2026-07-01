import 'package:field_track_todo/features/auth/login/screen/login_screen.dart';
import 'package:field_track_todo/features/auth/registration/screen/registration_screen.dart';
import 'package:field_track_todo/features/create_location/screen/create_location_screen.dart';
import 'package:field_track_todo/features/edit_location/screen/edit_location_screen.dart';
import 'package:field_track_todo/features/nav_bar/screen/nav_bar_screen.dart';
import 'package:field_track_todo/features/splash/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String navBarScreen = '/nav_bar_screen';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String createLocationScreen = '/create_location';
  static const String editLocationScreen = '/edit_location';

  static Map<String, WidgetBuilder> get routes => {
    splashScreen: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const RegistrationScreen(),
    navBarScreen: (context) => const NavBarScreen(),
    createLocationScreen: (context) => const CreateLocationScreen(),
    editLocationScreen: (context) => const EditLocationScreen(),
  };
}

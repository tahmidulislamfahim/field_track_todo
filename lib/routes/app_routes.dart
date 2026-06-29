

import 'package:field_track_todo/features/auth/login/screen/login_screen.dart';
import 'package:field_track_todo/features/auth/registration/screen/registration_screen.dart';
import 'package:field_track_todo/features/nav_bar/screen/nav_bar_screen.dart';
import 'package:field_track_todo/features/splash/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  // Onboarding screens
  static String splashScreen = '/splash_screen';
  static String navBarScreen = '/nav_bar_screen';

  // Authentication Screens
  static String login = '/login';
  static String signup = '/signup';

  static List<GetPage> routes = [
    // Onboarding screens
    GetPage(name: splashScreen, page: () => SplashScreen()),

    // Authentication Screens
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => RegistrationScreen()),
    GetPage(name: navBarScreen, page: () => NavBarScreen()),
  ];
}
import 'package:field_track_todo/features/auth/login/screen/login_screen.dart';
import 'package:field_track_todo/features/auth/registration/screen/registration_screen.dart';
import 'package:field_track_todo/features/create_location/screen/create_location_screen.dart';
import 'package:field_track_todo/features/edit_location/screen/edit_location_screen.dart';
import 'package:field_track_todo/features/nav_bar/screen/nav_bar_screen.dart';
import 'package:field_track_todo/features/splash/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = '/splash_screen';
  static String navBarScreen = '/nav_bar_screen';
  static String login = '/login';
  static String signup = '/signup';
  static String createLocationScreen = '/create_location';
  static String editLocationScreen = '/edit_location';

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => RegistrationScreen()),
    GetPage(name: navBarScreen, page: () => NavBarScreen()),
    GetPage(name: createLocationScreen, page: () => CreateLocationScreen()),
    GetPage(name: editLocationScreen, page: () => EditLocationScreen()),
  ];
}

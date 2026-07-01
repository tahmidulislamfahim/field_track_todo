import 'package:field_track_todo/core/theme/app_theme.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:field_track_todo/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FieldTrack',
      navigatorKey: NavigationService.navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
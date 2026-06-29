import 'package:field_track_todo/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FieldTrack',
      initialRoute: AppRoutes.splashScreen,
      // initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
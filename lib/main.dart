import 'package:flutter/material.dart';
import 'package:field_track_todo/app.dart';
import 'package:field_track_todo/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const App());
}
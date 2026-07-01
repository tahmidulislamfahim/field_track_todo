import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:field_track_todo/app.dart';
import 'package:field_track_todo/core/services/notification_service.dart';
import 'package:field_track_todo/core/services/provider_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  final container = ProviderContainer();
  ProviderContainerLocator.container = container;

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
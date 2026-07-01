import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navBarControllerProvider = ChangeNotifierProvider.autoDispose((ref) => NavBarController());

class NavBarController extends ChangeNotifier {
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}

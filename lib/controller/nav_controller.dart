import 'package:flutter/foundation.dart';

/// CONTROLLER: keeps the selected tab index.
class NavController extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }
}
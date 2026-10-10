import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lilac/model/splash_model.dart';



/// CONTROLLER: business logic (timer) exposed through Provider.
class SplashController extends ChangeNotifier {
  final SplashModel model = const SplashModel();

  Timer? _timer;
  bool _isFinished = false;
  bool get isFinished => _isFinished;

  /// Starts the 3-second timer, then calls [onFinished] (navigate to Home).
  void startTimer(VoidCallback onFinished) {
    _timer?.cancel();
    _timer = Timer(model.duration, () {
      _isFinished = true;
      notifyListeners();
      onFinished();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
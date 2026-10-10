import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lilac/service/shared_preferce.dart';

import '../core/app_constants.dart';


/// Login state + profile data, persisted with SharedPreferences.
class AuthController extends ChangeNotifier {
  final PreferencesService _prefs;
  AuthController({PreferencesService? prefs})
      : _prefs = prefs ?? PreferencesService();

  bool _isLoggedIn = false;
  String _name = kUserName;
  String _email = '';
  String? _imagePath;

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _name;
  String get email => _email;
  String? get imagePath => _imagePath;

  /// Call once before runApp().
  Future<void> init() async {
    await _prefs.init();
    _isLoggedIn = _prefs.isLoggedIn;
    _name = _prefs.name ?? kUserName;
    _email = _prefs.email ?? '';
    _imagePath = _prefs.imagePath;
  }

  Future<void> login({required String name, required String email}) async {
    await _prefs.saveLogin(name: name, email: email);
    _name = name;
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    await _prefs.setName(name);
    _name = name;
    notifyListeners();
  }

  Future<void> updateImage(String path) async {
    final old = _imagePath;
    await _prefs.setImagePath(path);
    _imagePath = path;
    notifyListeners();
    if (old != null && old != path) {
      try {
        await File(old).delete();
      } catch (_) {}
    }
  }

  /// Wipes SharedPreferences and logs out.
  Future<void> clearAll() async {
    await _prefs.clear();
    _isLoggedIn = false;
    _name = kUserName;
    _email = '';
    _imagePath = null;
    notifyListeners();
  }
}

import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences (login + profile data).
class PreferencesService {
  static const _kLoggedIn = 'is_logged_in';
  static const _kName = 'user_name';
  static const _kEmail = 'user_email';
  static const _kImage = 'profile_image_path';

  late SharedPreferences _p;

  Future<void> init() async => _p = await SharedPreferences.getInstance();

  bool get isLoggedIn => _p.getBool(_kLoggedIn) ?? false;
  String? get name => _p.getString(_kName);
  String? get email => _p.getString(_kEmail);
  String? get imagePath => _p.getString(_kImage);

  Future<void> saveLogin({required String name, required String email}) async {
    await _p.setString(_kName, name);
    await _p.setString(_kEmail, email);
    await _p.setBool(_kLoggedIn, true);
  }

  Future<void> setName(String name) => _p.setString(_kName, name);

  Future<void> setImagePath(String? path) async {
    if (path == null) {
      await _p.remove(_kImage);
    } else {
      await _p.setString(_kImage, path);
    }
  }

  /// "Clear Storage"
  Future<void> clear() => _p.clear();
}
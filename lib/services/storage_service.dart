import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email';
  static const String _rememberMeKey = 'remember_me';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveLoginData(
      String token, String email, bool rememberMe) async {
    if (rememberMe) {
      await _prefs.setString(_tokenKey, token);
      await _prefs.setString(_emailKey, email);
    }
    await _prefs.setBool(_rememberMeKey, rememberMe);
  }

  Future<void> clearLoginData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_emailKey);
    await _prefs.remove(_rememberMeKey);
  }

  String? getToken() => _prefs.getString(_tokenKey);

  String? getEmail() => _prefs.getString(_emailKey);

  bool getRememberMe() => _prefs.getBool(_rememberMeKey) ?? false;
}

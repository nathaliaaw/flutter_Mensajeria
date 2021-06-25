import 'package:shared_preferences/shared_preferences.dart';

class GeneralPreferences {
  static final GeneralPreferences _instance = GeneralPreferences.internal();

  factory GeneralPreferences() => _instance;

  GeneralPreferences.internal();

  SharedPreferences? _preferences;

  // ignore: constant_identifier_names
  static const String KEY_TOKEN = "token";

  initPreferences() async {
    _preferences = await SharedPreferences?.getInstance();
  }

  String get getToken => _preferences!.getString(KEY_TOKEN) ?? '';
  void setToken(String value) => _preferences!.setString(KEY_TOKEN, value);
}
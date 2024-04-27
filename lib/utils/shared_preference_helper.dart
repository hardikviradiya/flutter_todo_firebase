import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _userIdKey = 'userId';

  // Singleton pattern
  static final SharedPreferenceHelper _instance = SharedPreferenceHelper._();

  factory SharedPreferenceHelper() => _instance;

  SharedPreferenceHelper._();

  SharedPreferences? _preferences;

  // Initialize SharedPreferences
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Getters and setters for user details
  String get userId => _preferences?.getString(_userIdKey) ?? "";

  set userId(String? value) {
    _preferences?.setString(_userIdKey, value ?? '');
  }
}

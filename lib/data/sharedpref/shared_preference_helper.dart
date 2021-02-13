import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final Future<SharedPreferences> _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  Future<String> get authToken async {
    return _sharedPreference.then((preference) {
      return preference.getString(Preferences.auth_token);
    });
  }

  Future<void> saveAuthToken(String authToken) async {
    return _sharedPreference.then((preference) {
      preference.setString(Preferences.auth_token, authToken);
    });
  }

  Future<void> saveUserId(int id) async {
    return _sharedPreference.then((preference) {
      preference.setInt(Preferences.userId, id);
    });
  }

  Future<void> setAuthData(dynamic result) async {
    return saveAuthToken(result["result"]["accessToken"])
        .then((val) => saveUserId(result["result"]["userId"]));
  }

  Future<void> removeAuthToken() async {
    return _sharedPreference.then((preference) {
      preference.remove(Preferences.auth_token);
    });
  }

  Future<bool> logOut() async {
    try {
      return _sharedPreference.then((preference) {
        preference.remove(Preferences.auth_token);
        preference.remove(Preferences.userId);
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<void> removeUser() async {
    return _sharedPreference.then((preference) {
      preference.remove(Preferences.userId);
    });
  }

  Future<bool> get isLoggedIn async {
    return _sharedPreference.then((preference) {
      return preference.getString(Preferences.auth_token) == null
          ? false
          : true;
    });
  }

  // Theme:------------------------------------------------------
  Future<bool> get isDarkMode {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(Preferences.is_dark_mode) ?? false;
    });
  }

  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(Preferences.is_dark_mode, value);
    });
  }

  // Language:---------------------------------------------------
  Future<String> get currentLanguage {
    return _sharedPreference.then((prefs) {
      return prefs.getString(Preferences.current_language);
    });
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(Preferences.current_language, language);
    });
  }

  Future<int> get userId {
    return _sharedPreference.then((prefs) {
      return prefs.getInt(Preferences.userId);
    });
  }
}

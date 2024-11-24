import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenced {
  setLoginStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("auth", value);
  }

  Future<bool?> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('auth');
  }

  Future removeLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove('auth');
  }
}

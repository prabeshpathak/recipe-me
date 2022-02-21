import 'package:recipe_app_flutter/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreference {
  Future<bool> verifyUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('verified', true);
  }

  Future<bool> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.userId);
    await prefs.setString('name', user.name);
    await prefs.setBool('verified', user.verified);

    return await prefs.setString('token', user.token);
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String userId = prefs.getString('userId') ?? 'null';
    final String name = prefs.getString('name') ?? 'null';
    final String token = prefs.getString('token') ?? 'null';
    final bool verified = prefs.getBool('verified') ?? false;
    return User(userId: userId, name: name, token: token, verified: verified);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('name');
    await prefs.remove('token');
    await prefs.remove('verified');
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? 'null';
    return token;
  }
}

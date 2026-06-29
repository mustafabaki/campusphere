import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../auxiliary/constants.dart';
import '../../services/push_notification_service.dart';
import '../main_shell.dart';

class LoginFunctions {
  static Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(baseURL + loginEndpoint),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      // save the token on SharedPreferences ...
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var result = jsonDecode(response.body);
      sharedPreferences.setString("token", result["data"]);

      // Register the FCM device token with the backend
      await PushNotificationService.registerDeviceToken();

      // Navigate to the main application shell
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  static Future<bool> shouldLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");

    if (token == null) {
      return true; // Should login since there's no token
    } else {
      try {
        final parts = token.split('.');
        final payload = parts[1];
        final String normalized = base64Url.normalize(payload);
        final String decoded = utf8.decode(base64Url.decode(normalized));
        final Map<String, dynamic> data = jsonDecode(decoded);

        if (data.containsKey('exp')) {
          final int exp = data['exp'];
          final DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(
            exp * 1000,
          );
          if (DateTime.now().isAfter(expirationDate)) {
            return true; // Token has expired, should login
          }
        }
        return false; // Token is valid, no need to login
      } catch (e) {
        return true; // Error parsing token, should login
      }
    }
  }
}

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

      // fetch the name of the user and save it to the SharedPreferences
      // (must happen BEFORE navigation so the home page can read it)
      final uri = Uri.parse(
        baseURL + studentByEmailEndpoint,
      ).replace(queryParameters: {'email': email});

      final usernameResponse = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${result['data']}",
        },
      );

      if (usernameResponse.statusCode == 200) {
        final usernameResult = jsonDecode(usernameResponse.body);
        sharedPreferences.setString("name", usernameResult["data"]["name"]);
      }

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

  /// Determines whether the user needs to authenticate.
  ///
  /// Checks [SharedPreferences] for a stored JWT token and validates it:
  /// 1. If no token exists, the user must log in.
  /// 2. If a token exists, its `exp` (expiration) claim is decoded and
  ///    compared against the current time.
  ///
  /// The JWT payload is extracted by Base64-decoding the second segment
  /// of the token.
  ///
  /// Returns `true` if the user should be redirected to the login screen
  /// (no token, expired token, or a parsing error), and `false` if the
  /// token is still valid.
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

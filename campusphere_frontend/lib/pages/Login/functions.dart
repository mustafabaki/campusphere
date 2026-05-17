import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../auxiliary/constants.dart';
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
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var result = jsonDecode(response.body);
      sharedPreferences.setString("token", result["data"]);
      
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
}

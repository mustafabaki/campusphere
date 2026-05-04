import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../auxiliary/constants.dart';

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
      
      // Navigate to home page
      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );*/
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }
}

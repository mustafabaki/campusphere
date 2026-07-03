import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auxiliary/constants.dart';

/// Service responsible for fetching home page data from the backend.
///
/// Currently uses the existing student endpoint to retrieve the
/// logged-in student's name for the greeting section.
class HomeFeedService {
  /// Extracts the user's email from the stored JWT token.
  ///
  /// Returns `null` if no token is found or the token cannot be parsed.
  static Future<String?> _getEmailFromJwt() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    try {
      final parts = token.split('.');
      final payload = parts[1];
      final String normalized = base64Url.normalize(payload);
      final String decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> data = jsonDecode(decoded);
      return data['sub'] as String?;
    } catch (e) {
      debugPrint('[HomeFeedService] Error parsing JWT: $e');
      return null;
    }
  }

  /// Retrieves the student's name from local storage.
  ///
  /// Reads the `"name"` key from [SharedPreferences] and returns its value.
  ///
  /// Returns the student's name as a [String], or `null` if the name
  /// is not stored or an error occurs during retrieval.
  static Future<String?> fetchStudentName() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // fetch the name of the user from the SharedPreferences...
      String? name = sharedPreferences.getString("name");
      return name;
    } catch (e) {
      debugPrint('[HomeFeedService] Error fetching student name: $e');
    }
    return null;
  }
}

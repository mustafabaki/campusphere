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

  /// Fetches the logged-in student's first name from the backend.
  ///
  /// Uses `GET /api/student/getStudentByEmail` with the email extracted
  /// from the JWT token. Returns the student's first name, or `null`
  /// on failure.
  static Future<String?> fetchStudentName() async {
    try {
      final email = await _getEmailFromJwt();
      if (email == null) {
        debugPrint('[HomeFeedService] No email found in JWT');
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('token');
      if (jwt == null) return null;

      final uri = Uri.parse(baseURL + studentByEmailEndpoint)
          .replace(queryParameters: {'email': email});

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true && result['data'] != null) {
          final studentData = result['data'];
          return studentData['name'] as String?;
        }
      } else {
        debugPrint(
          '[HomeFeedService] Failed to fetch student — status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('[HomeFeedService] Error fetching student name: $e');
    }
    return null;
  }
}

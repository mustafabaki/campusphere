
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../auxiliary/constants.dart';



/// Service responsible for fetching home page data from the backend.
///
/// Currently uses the existing student endpoint to retrieve the
/// logged-in student's name for the greeting section.
class HomeFeedService {
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

  /// Retrieves the student's profile picture URL from local storage.
  ///
  /// Reads the `"profilePictureURL"` key from [SharedPreferences] and returns its value.
  ///
  /// Returns the profile picture URL as a [String], or `null` if the URL
  /// is not stored or an error occurs during retrieval.
  static Future<String?> fetchProfilePictureURL() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // fetch the profile picture URL of the user from the SharedPreferences...
      String? profilePictureURL = sharedPreferences.getString("profilePictureURL");
      return profilePictureURL;
    } catch (e) {
      debugPrint('[HomeFeedService] Error fetching profile picture URL: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> fetchRandomUpcomingEvent() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var response = await http.get(
        Uri.parse(baseURL + getRandomUpcomingEventEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        },
      );

      if (response.statusCode == 200) {
        debugPrint('[HomeFeedService] Random upcoming event: ${response.body}');
        return jsonDecode(response.body);
      }
      else {
        debugPrint('[HomeFeedService] Error fetching random upcoming event: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('[HomeFeedService] Error fetching random upcoming event: $e');
    }
    return null;
  }

  
}


import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
}

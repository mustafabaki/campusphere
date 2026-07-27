import 'dart:convert';

import 'package:campusphere_frontend/auxiliary/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailsService {
  
  /// Fetches the first three event registrations for a specific [eventId].
  ///
  /// This is typically used to display a preview of the attendees registered for an event.
  /// Returns a list of maps containing registration details if the request is successful.
  /// Returns `null` if the request fails, or if an error occurs during execution.
  static Future<List<Map<String, dynamic>>?> fetchFirstThreeEventRegistrations(
    String eventId,
  ) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final response = await http.get(
        Uri.parse(
          baseURL + getFirstThreeEventRegistrationsEndpoint,
        ).replace(queryParameters: {'eventId': eventId}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        },
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['data'].cast<Map<String, dynamic>>();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

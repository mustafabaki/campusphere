import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auxiliary/constants.dart';

/// Top-level handler for background / terminated messages.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message received: ${message.messageId}');
  debugPrint('[FCM]   Title : ${message.notification?.title}');
  debugPrint('[FCM]   Body  : ${message.notification?.body}');
  debugPrint('[FCM]   Data  : ${message.data}');
}

/// Singleton service that manages Firebase Cloud Messaging.
///
/// Responsibilities:
///  • Request notification permissions (iOS + Android 13+)
///  • Retrieve and persist the FCM device token
///  • Listen for token refreshes and re-register with the backend
///  • Handle foreground, background, and terminated-state messages
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService _instance = PushNotificationService._();
  factory PushNotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // ─── Initialisation ──────────────────────────────────────

  /// Call once after `Firebase.initializeApp()`.
  Future<void> initialize() async {
    // Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permissions (iOS always, Android 13+)
    await _requestPermission();

    // Retrieve and cache the FCM token
    await _retrieveToken();

    // Listen for token refreshes
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[FCM] Token refreshed: $newToken');
      _cacheToken(newToken);
      _sendTokenToBackend(newToken);
    });

    // ── Foreground message handling ──────────────────────────
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FCM] Foreground message: ${message.messageId}');
      _handleMessage(message);
    });

    // ── User tapped on a notification (app was in background) ─
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[FCM] Notification opened app: ${message.messageId}');
      _handleNotificationTap(message);
    });

    // ── App was terminated & launched by a notification ───────
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[FCM] App launched from terminated via notification');
      _handleNotificationTap(initialMessage);
    }

    // Set foreground notification presentation options (iOS)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ─── Permission ──────────────────────────────────────────

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');
  }

  // ─── Token Management ────────────────────────────────────

  /// On iOS, the APNS token arrives asynchronously after the app registers
  /// for remote notifications. We must wait for it before calling `getToken()`.
  /// On the iOS Simulator, APNS tokens are never delivered — this will time
  /// out gracefully and the token will be `null`.
  Future<void> _retrieveToken() async {
    try {
      // On iOS, wait for the APNS token before requesting the FCM token
      if (!kIsWeb && Platform.isIOS) {
        String? apnsToken;
        // Retry up to 10 times (every 1s) waiting for the APNS token
        for (int i = 0; i < 10; i++) {
          apnsToken = await _messaging.getAPNSToken();
          if (apnsToken != null) break;
          debugPrint('[FCM] Waiting for APNS token... (${i + 1}/10)');
          await Future.delayed(const Duration(seconds: 1));
        }
        if (apnsToken == null) {
          debugPrint(
            '[FCM] ⚠️ APNS token not available. '
            'Push notifications require a physical iOS device. '
            'Skipping FCM token retrieval.',
          );
          return;
        }
      }

      final token = await _messaging.getToken();
      if (token != null) {
        debugPrint('[FCM] Device token: $token');
        await _cacheToken(token);
      }
    } catch (e) {
      debugPrint('[FCM] Error retrieving token: $e');
    }
  }

  /// Persist the token locally so the login flow can pick it up.
  Future<void> _cacheToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  /// Get the cached FCM token.
  static Future<String?> getCachedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  /// Send the FCM token to the backend, attaching the JWT for auth.
  /// This is called after login or when the token refreshes.
  Future<void> _sendTokenToBackend(String fcmToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('token');
      if (jwt == null) {
        debugPrint('[FCM] No JWT found — skipping backend token registration');
        return;
      }

      final response = await http.put(
        Uri.parse(baseURL + deviceTokenEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode({'deviceToken': fcmToken}),
      );

      if (response.statusCode == 200) {
        debugPrint('[FCM] Device token registered with backend');
      } else {
        debugPrint(
          '[FCM] Failed to register token — status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('[FCM] Error sending token to backend: $e');
    }
  }

  /// Public method called from the login flow after authentication.
  static Future<void> registerDeviceToken() async {
    final service = PushNotificationService();
    final token = await getCachedToken();
    if (token != null) {
      await service._sendTokenToBackend(token);
    } else {
      debugPrint('[FCM] No cached FCM token available to register');
    }
  }

  // ─── Message Handling ────────────────────────────────────

  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      debugPrint('[FCM] 📬 ${notification.title}: ${notification.body}');
    }

    // Handle data payloads
    if (message.data.isNotEmpty) {
      debugPrint('[FCM] Data payload: ${message.data}');
      _processDataPayload(message.data);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('[FCM] User tapped notification: ${message.data}');

    // Navigate based on the data payload
    // Example: if the data contains a 'type' and 'id', route accordingly
    if (message.data.containsKey('type')) {
      final type = message.data['type'];
      final id = message.data['id'];
      debugPrint('[FCM] Navigation target — type: $type, id: $id');
      // TODO: Implement deep-link navigation based on notification type
    }
  }

  void _processDataPayload(Map<String, dynamic> data) {
    // Process any silent data messages from the backend
    // e.g., badge count updates, cache invalidation signals, etc.
    debugPrint('[FCM] Processing data payload: $data');
  }
}

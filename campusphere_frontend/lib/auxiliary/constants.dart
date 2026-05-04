import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

String get baseURL {
  if (kIsWeb) {
    return "http://localhost:8080";
  } else if (Platform.isAndroid) {
    // Android emulator uses 10.0.2.2 to access the host machine's localhost
    return "http://10.0.2.2:8080";
  } else {
    // iOS simulator and desktop apps can use localhost
    return "http://localhost:8080";
  }
}

const String loginEndpoint = "/api/auth/login";

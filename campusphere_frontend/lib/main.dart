import 'package:campusphere_frontend/auxiliary/app_theme.dart';
import 'package:campusphere_frontend/firebase_options.dart';
import 'package:campusphere_frontend/pages/Login/functions.dart';
import 'package:campusphere_frontend/pages/Login/login.dart';
import 'package:campusphere_frontend/pages/main_shell.dart';
import 'package:campusphere_frontend/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FCM: request permissions, retrieve token, set up listeners
  await PushNotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool shouldLogin = true;

  @override
  void initState() {
    super.initState();
    LoginFunctions.shouldLogin().then(
      (value) => {
        setState(() {
          shouldLogin = value;
        }),
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampuSphere',
      theme: AppTheme.lightTheme,
      home: shouldLogin ? LoginPage() : MainShell(),
    );
  }
}

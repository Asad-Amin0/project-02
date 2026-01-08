import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 🔹 Initialize Firebase
    await Firebase.initializeApp();

    // 🔹 Initialize AdMob
    await MobileAds.instance.initialize();
  } catch (e, stack) {
    debugPrint("Error initializing Firebase or AdMob: $e");
    debugPrintStack(stackTrace: stack);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QR & Chat App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 🔹 Show loading while checking auth state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            // 🔹 User is logged in
            return const HomeScreen();
          } else {
            // 🔹 User not logged in
            return LoginScreen();
          }
        },
      ),
    );
  }
}

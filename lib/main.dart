import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Import the generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: const RegisterPage(),
      home: SplashScreen()
      // home:UserProfile()
    );

  }
}




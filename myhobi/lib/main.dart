import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Pastikan file ini diimport
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Sekarang panggil Firebase dengan options hasil generate tadi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ini kuncinya!
  );
  
  runApp(const MyHobiApp());
}

class MyHobiApp extends StatelessWidget {
  const MyHobiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyHobi',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blueAccent,
      ),
      home: const SplashScreen(),
    );
  }
}
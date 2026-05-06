// screens/splash/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_screen.dart';
import 'main_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    // Delay selama 3 detik agar user bisa melihat splash screen
    Timer(const Duration(seconds: 3), () {
      // Cek apakah user sudah login sebelumnya
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (mounted) {
          if (user == null) {
            // Jika belum login, lempar ke halaman Sign In
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          } else {
            // Jika sudah login, langsung ke Dashboard (MainWrapper)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainWrapper()),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            // Ganti dengan path file gambar splash kamu
            image: AssetImage('assets/images/MyHobi.png'), 
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyHobiApp(),
    ),
  );
}

class MyHobiApp extends StatelessWidget {
  const MyHobiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil provider untuk memantau perubahan tema
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyHobi',
      // Tema dinamis berdasarkan pilihan user
      theme: themeProvider.currentTheme,
      home: const SplashScreen(),
    );
  }
}
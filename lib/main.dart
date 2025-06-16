import 'package:flutter/material.dart';
import 'splash_screen.dart'; // arahkan ke splash_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Apps',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const SplashScreen(), // <== arahkan ke SplashScreen di sini
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CineHubApp());
}

class CineHubApp extends StatelessWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF131313),
        cardColor: const Color(0xFF1C1C1E),
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}

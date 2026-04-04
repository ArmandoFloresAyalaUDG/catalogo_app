import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      // Scaffold nos da la estructura básica visual (barra superior, cuerpo, etc.)
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'), // Aquí está el título
        ),
        body: const Center(
          child: Text('Hello World!'), // Aquí está el texto centrado
        ),
      ),
    );
  }
}
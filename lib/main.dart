// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/library_screen.dart';

void main() {
  runApp(const DestiniApp());
}

class DestiniApp extends StatelessWidget {
  const DestiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Destini Multi-Story App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LibraryScreen(),
    );
  }
}

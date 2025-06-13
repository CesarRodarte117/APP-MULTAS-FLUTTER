import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// DB MODELS
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
// VIEWS
import 'package:multas/views/login.dart';
// CONTROLLERS

void main() {
  runApp(const MyApp());
}

// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multas App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}

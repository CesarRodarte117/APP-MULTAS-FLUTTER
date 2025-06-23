import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// DB MODELS
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
// VIEWS
import 'package:multas/views/login.dart';
// CONTROLLERS
import 'package:multas/funciones_especiales/verificar_session.dart';

void main() {
  runApp(const MyApp());
  bool sessionActive = false;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey,
      // home:  LoginPage(),
      home: FutureBuilder(
        future: verificarSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.data!) {
            return const LoginPage();
          } else {
            return const LoginPage(); // Aquí puedes cambiar a la vista principal
          }
        },
      ),
    );
  }
}

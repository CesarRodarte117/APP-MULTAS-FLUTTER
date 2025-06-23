import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// DB MODELS
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
// VIEWS
import 'package:multas/views/login.dart';
import 'package:multas/views/menu_principal.dart';
// CONTROLLERS

//funciones especiales
import 'package:multas/funciones_especiales/verificar_session.dart';

void main() {
  runApp(const MyApp());
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
      home: FutureBuilder(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras se verifica la sesión, muestra un CircularProgressIndicator
            return const Center(child: CircularProgressIndicator());
          } else {
            // Verifica si hay sesión activa
            return FutureBuilder<bool>(
              future: AuthService.isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == true) {
                  // Si hay sesión activa, muestra el menú principal
                  return MenuPrincipal();
                } else {
                  // Si no hay sesión, muestra la página de login
                  return const LoginPage();
                }
              },
            );
          }
        },
      ),
    );
  }
}

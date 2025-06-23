import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// DB MODELS
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
// VIEWS
import 'package:multas/views/login.dart';
import 'package:multas/views/menu_principal.dart';
// CONTROLLERS

// Servicios
import 'package:multas/funciones_especiales/verificar_session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          // Mientras verifica
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 124, 36, 57),
                ),
              ),
            );
          }

          // Decide a dónde ir
          if (snapshot.data == true) {
            return MenuPrincipal(); // Si ya inició sesión
          } else {
            return LoginPage(); // Si no ha iniciado sesión
          }
        },
      ),
    );
  }
}

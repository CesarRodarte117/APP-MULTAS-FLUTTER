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

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Importante para SharedPreferences
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          // Mientras se carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Cuando ya tenemos respuesta
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? MenuPrincipal() : const LoginPage();
        },
      ),
    );
  }
}

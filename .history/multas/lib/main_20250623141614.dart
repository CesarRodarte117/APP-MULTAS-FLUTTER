import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// DB MODELS
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
// VIEWS
import 'package:multas/views/login.dart';
import 'package:multas/views/menu_principal.dart';
// CONTROLLERS
import 'package:multas/funciones_especiales/verificar_session.dart';

void main() {
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
        future: _checkSession(context),
        builder: (context, snapshot) {
          // Mientras se verifica la sesión, muestra un loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Si hay error o sesión inválida, va a LoginPage
          if (snapshot.hasError || !snapshot.data!) {
            return const LoginPage();
          }

          // Sesión válida, pero el navigation ya se manejó en verificarSession
          return const LoginPage(); // Este widget no se mostrará
        },
      ),
    );
  }

  Future<bool> _checkSession(BuildContext context) async {
    try {
      return await verificarSession(context);
    } catch (e) {
      return false;
    }
  }
}

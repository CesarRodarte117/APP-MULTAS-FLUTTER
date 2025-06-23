import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// DB MODELS
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
// VIEWS
import 'package:multas/views/login.dart';
import 'package:multas/views/menu_principal.dart'; // Asegúrate de importar tu vista principal
// CONTROLLERS
import 'package:multas/funciones_especiales/verificar_session.dart';

void main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Ejecutar verificación de sesión antes de iniciar la app
  final bool sessionValida = await verificarSession(
    navigatorKey.currentContext!,
  );

  runApp(MyApp(sessionValida: sessionValida));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final bool sessionValida;

  const MyApp({super.key, required this.sessionValida});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multas App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      navigatorKey: navigatorKey,
      home: sessionValida ? MenuPrincipal() : LoginPage(),
    );
  }
}

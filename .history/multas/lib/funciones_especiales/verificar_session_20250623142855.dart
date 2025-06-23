import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multas/views/menu_principal.dart';

Future<bool> verificarSession(BuildContext context) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Verificar múltiples condiciones para sesión válida
    final bool? sessionActive = prefs.getBool('session_active');
    final String? matricula = prefs.getString('matricula');
    final String? password = prefs.getString('password');

    // Validación básica (puedes personalizar según tus necesidades)
    const validMatricula = '666';
    const validPassword = '666';

    final bool isValidSession =
        sessionActive == true &&
        matricula != null &&
        password != null &&
        matricula == validMatricula &&
        password == validPassword;

    if (isValidSession) {
      // Navegar al menú principal si la sesión es válida
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuPrincipal()),
        );
      });
      return true;
    }

    return false;
  } catch (e) {
    return false;
  }
}

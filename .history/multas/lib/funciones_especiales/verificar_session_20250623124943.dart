import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import'
import 'package:multas/views/menu_principal.dart';

Future<bool> verificarSession(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? sessionActive = prefs.getBool('session_active');

  if (sessionActive == null || !sessionActive) {
    return false; // No hay sesión activa
  }

  // Aquí podrías agregar más lógica para verificar la validez de la sesión
  // como comprobar si el token ha expirado, etc.

  //dirigir a la vista principal si la sesión es válida
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MenuPrincipal()),
  );

  return true; // Sesión activa
}

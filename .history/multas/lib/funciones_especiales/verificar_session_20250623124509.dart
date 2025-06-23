import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import'
'package:multas/views/menu_principal.dart';

Future<bool> verificarSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? sessionActive = prefs.getBool('session_active');

  if (sessionActive == null || !sessionActive) {
    return false; // No hay sesión activa
  }

  // Aquí podrías agregar más lógica para verificar la validez de la sesión
  // como comprobar si el token ha expirado, etc.

  return true; // Sesión activa
}

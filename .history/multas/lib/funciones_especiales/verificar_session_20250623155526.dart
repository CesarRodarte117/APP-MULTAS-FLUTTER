import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multas/views/menu_principal.dart';

class AuthService {
  // Guardar datos de sesión
  static Future<void> saveSession(String password, String matricula) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('matricula', matricula);
    await prefs.setString('password', password);
    await prefs.setBool('is_logged_in', true);
  }

  // Verificar si hay sesión activa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Obtener token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('matricula');
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('matricula');
    await prefs.remove('password');
    await prefs.setBool('is_logged_in', false);
  }
}

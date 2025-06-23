import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multas/views/menu_principal.dart';

class AuthService {
  // Guardar datos de sesión
  Future<void> saveSession(String password, String matricula) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('matricula', matricula);
    await prefs.setString('password', password);
    await prefs.setBool('is_logged_in', true);
  }

  // Verificar si hay sesión activa
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Obtener token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('matricula');
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('matricula');
    await prefs.remove('password');
    await prefs.setBool('is_logged_in', false);
  }
}

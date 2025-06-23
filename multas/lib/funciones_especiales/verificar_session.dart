import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyMatricula = 'matricula';
  static const _keyPassword = 'password';

  // Guardar sesión de forma persistente
  static Future<void> saveSession(String matricula, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        // Guardamos datos sensibles en almacenamiento seguro
        _storage.write(key: _keyMatricula, value: matricula),
        _storage.write(key: _keyPassword, value: password),
        // Usamos SharedPreferences para el flag de sesión
        prefs.setBool(_keyIsLoggedIn, true),
      ]);
    } catch (e) {
      throw Exception('Error al guardar sesión: $e');
    }
  }

  // Verificar sesión de forma robusta
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

      if (isLoggedIn) {
        // Verificamos que existan las credenciales seguras
        final matricula = await _storage.read(key: _keyMatricula);
        final password = await _storage.read(key: _keyPassword);
        return matricula != null && password != null;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Obtener matrícula
  static Future<String?> getMatricula() async {
    return await _storage.read(key: _keyMatricula);
  }

  // Cerrar sesión completamente
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        _storage.delete(key: _keyMatricula),
        _storage.delete(key: _keyPassword),
        prefs.setBool(_keyIsLoggedIn, false),
      ]);
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }
}

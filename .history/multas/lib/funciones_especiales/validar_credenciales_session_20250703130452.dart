import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multas/models/db.dart';
import 'package:intl/intl.dart';

class AutenticacionUsuario {
  final DatabaseHelper dbHelper;
  final String baseUrl;

  AutenticacionUsuario({
    required this.dbHelper,
    this.baseUrl = 'https://dev2.tarkus.app/multas/servicios',
  });

  /// Valida las credenciales de un agente usando el endpoint WS_LOGIN
  /// Devuelve `true` si son válidas, `false` en caso contrario
  Future<bool> validarCredenciales({
    required String matricula,
    required String password,
  }) async {
    try {
      // 1. Obtener fecha/hora de la base de datos (como en el código Delphi)
      final fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print('Fecha actual: $fechaActual');
      // 2. Construir URL según el formato WS_LOGIN
      final url = Uri.parse(
        '$baseUrl/login.json?clave=$matricula&contrasena=$password&tipo=Nueva&dbFechaHora=$fechaActual',
      );

      // 3. Hacer la petición POST (como indica WS_LOGIN)
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Verificar estructura de respuesta similar al código Delphi
        if (jsonResponse['status'] == 'Ok') {
          // Guardar datos de sesión como en el ejemplo Delphi
          await _guardarDatosSesion(
            matricula: matricula,
            password: password,
            respuesta: jsonResponse,
          );
          return true;
        }
      }

      return false;
    } catch (e) {
      // Fallback: Verificar si el agente existe localmente
      return await false; //_validarCredencialesLocales(matricula, password);
    }
  }

  // /// Guarda los datos de sesión como en el código Delphi original
  Future<void> _guardarDatosSesion({
    required String matricula,
    required String password,
    required Map<String, dynamic> respuesta,
  }) async {
    // 1. Guardar token y datos del agente
    // await dbHelper.insertSesion(
    //   matricula: matricula,
    //   nombreAgente: respuesta['nombre_agente']?.toString() ?? '',
    //   token: respuesta['token']?.toString() ?? '',
    // );

    // 2. Procesar folios si existen (como en Delphi)
    // if (respuesta['folios'] != null) {
    //   final folios = respuesta['folios'] as Map<String, dynamic>;
    //   // if (folios['status'] == 'Ok') {
    //   //   await dbHelper.insertFolios(
    //   //     folioIni: folios['folioini'] as int,
    //   //     folioFin: folios['foliofin'] as int,
    //   //   );
    //   // }
    // }

    // 3. Guardar credenciales para futuros inicios de sesión
    // await AuthService.saveSession(password, matricula);
  }

  // /// Valida contra la base de datos local
  // Future<bool> _validarCredencialesLocales(
  //   String matricula,
  //   String password,
  // ) async {
  //   final agentes = await dbHelper.getAgentes();
  //   return agentes.any((a) => a.clave == matricula && a.contrasena == password);
  // }

  // /// Guarda la sesión en preferencias (como en tu ejemplo)
  // static Future<void> saveSession(String password, String matricula) async {
  //   // Implementación usando SharedPreferences o similar
  //   // ...
  // }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';

class CatalogoService {
  final DatabaseHelper dbHelper;
  final String token;

  CatalogoService({
    required this.dbHelper,
    this.token = '123e4567-e89b-12d3-a456-426614174000',
  });

  Future<bool> descargarCalles({bool actualizar = false}) async {
    int bloque = 1;
    int numBloques = 0;

    try {
      // 1. Verificar si ya hay datos y no se fuerza actualización
      if (!actualizar) {
        final count = await dbHelper.countCalles();
        if (count > 0) {
          return true; // Ya hay datos, no es necesario descargar
        }
      }

      // 2. Borrar datos existentes si es una actualización
      if (actualizar) {
        await dbHelper.deleteAllCalles();
      }

      // 3. Descargar por bloques
      do {
        final response = await http.post(
          Uri.parse(
            'https://dev2.tarkus.app/multas/servicios/gestion_catalogo.json?'
            'token=${this.token}&catalogo=calles&bloque=$bloque',
          ),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final registros = jsonResponse['registros'] as List;

          // Insertar directamente en la DB sin lista intermedia
          for (final registro in registros) {
            await dbHelper.insertCalle(Calle.fromJson(registro));
          }

          numBloques = jsonResponse['numbloques'] ?? 0;
          bloque++;
        } else {
          return false; // Error en la petición HTTP
        }
      } while (bloque <= numBloques);

      return true; // Éxito total
    } catch (e) {
      // Fallback a datos locales
      final callesLocales = await dbHelper.getCalles();
      final count = await dbHelper.countCalles();
      if (callesLocales.isEmpty) {
        return false;
      } else {
        return count > 0; // Retorna true si hay datos locales
      }
    }
  }

  Future<bool> descargarColonias({bool actualizar = false}) async {
    int bloque = 1;
    int numBloques = 0;

    try {
      // 1. Verificar si ya hay datos y no se fuerza actualización
      if (!actualizar) {
        final count = await dbHelper.countColonias();
        if (count > 0) {
          return true; // Ya hay datos, no es necesario descargar
        }
      }

      // 2. Borrar datos existentes si es una actualización
      if (actualizar) {
        await dbHelper.deleteAllColonias();
      }

      // 3. Descargar por bloques
      do {
        final response = await http.post(
          Uri.parse(
            'https://dev2.tarkus.app/multas/servicios/gestion_catalogo.json?'
            'token=${this.token}&catalogo=colonias&bloque=$bloque',
          ),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final registros = jsonResponse['registros'] as List;

          // Insertar directamente en la DB sin lista intermedia
          for (final registro in registros) {
            await dbHelper.insertCalle(Calle.fromJson(registro));
          }

          numBloques = jsonResponse['numbloques'] ?? 0;
          bloque++;
        } else {
          return false; // Error en la petición HTTP
        }
      } while (bloque <= numBloques);

      return true; // Éxito total
    } catch (e) {
      // Fallback a datos locales
      final callesLocales = await dbHelper.getCalles();
      final count = await dbHelper.countCalles();
      if (callesLocales.isEmpty) {
        return false;
      } else {
        return count > 0; // Retorna true si hay datos locales
      }
    }
  }
}

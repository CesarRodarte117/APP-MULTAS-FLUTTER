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

  Future<void> descargarCalles({bool actualizar = false}) async {
    int bloque = 1;
    int numBloques = 0;
    final List<Calle> callesDescargadas = [];

    try {
      // Verificar datos locales
      final count = await dbHelper.countCalles();
      if (count > 0 && !actualizar) {
        await dbHelper.getCalles();
        return true; // Si hay datos locales y no se requiere actualización, salir
      }

      if (actualizar) {
        await dbHelper.deleteAllCalles();
      }

      do {
        final url = Uri.parse(
          'https://dev2.tarkus.app/multas/servicios/gestion_catalogo.json?'
                  'token=&' +
              this.token +
              '&catalogo=calles&bloque=$bloque', // Token fijo
        );

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          }, // Añade headers si es necesario
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final registros = jsonResponse['registros'] as List;

          callesDescargadas.addAll(
            registros.map((json) => Calle.fromJson(json)).toList(),
          );

          // Insertar en DB local
          for (final calle in callesDescargadas) {
            await dbHelper.insertCalle(calle);
          }

          bloque++;
          numBloques = jsonResponse['numbloques'] ?? 0;
        }
      } while (bloque <= numBloques);

      return true;
    } catch (e) {
      // Fallback a datos locales
      final callesLocales = await dbHelper.getCalles();
      if (callesLocales.isNotEmpty) return false;
      throw Exception('Error descargando calles: $e');
    }
  }
}

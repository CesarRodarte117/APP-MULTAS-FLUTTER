import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogoService {
  final String baseUrl;
  final String token;
  final DatabaseHelper dbHelper;

  CatalogoService({
    required this.baseUrl,
    required this.token,
    required this.dbHelper,
  });

  Future<List<Calle>> descargarCalles({bool actualizar = false}) async {
    int bloque = 1;
    int numBloques = 0;
    final List<Calle> callesDescargadas = [];

    try {
      // Verificar si hay datos locales y no se requiere actualizar
      final count = await dbHelper.countCalles();
      if (count > 0 && !actualizar) {
        return await dbHelper.getCalles();
      }

      // Si se requiere actualizar, borrar todos los datos existentes
      if (actualizar) {
        await dbHelper.deleteAllCalles();
      }

      // Descargar por bloques
      do {
        final url = Uri.parse(
          '$baseUrl/multas/servicios/gestion_catalogo.json?token=$token&catalogo=calles&bloque=$bloque',
        );
        final response = await http.post(url);

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final jres = jsonResponse;

          if (bloque == 1) {
            numBloques = jres['numbloques'] ?? 0;
          }

          final porcentaje = (bloque * 100) ~/ numBloques;

          // Actualizar UI con el progreso (usar Provider o similar)
          // updateProgress('Calles $porcentaje%');

          final registros = jres['registros'] as List;
          final callesBloque = registros
              .map((valor) => Calle.fromJson(valor))
              .toList();

          // Insertar en la base de datos local
          for (final calle in callesBloque) {
            await dbHelper.insertCalle(calle);
          }

          callesDescargadas.addAll(callesBloque);
          bloque++;
        } else {
          throw Exception('Error al descargar calles: ${response.statusCode}');
        }
      } while (bloque <= numBloques);

      return callesDescargadas;
    } catch (e) {
      // Si hay error, intentar devolver las calles locales
      final callesLocales = await dbHelper.getCalles();
      if (callesLocales.isNotEmpty) {
        return callesLocales;
      }
      throw Exception('Error en descargarCalles: $e');
    }
  }
}

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

  // Método genérico para descargar cualquier catálogo
  Future<bool> _descargarCatalogo<T>({
    required String nombreCatalogo,
    required Future<int> Function() countLocal,
    required Future<void> Function() deleteAll,
    required Future<void> Function(T) insert,
    required Future<List<T>> Function() getLocal,
    required T Function(Map<String, dynamic>) fromJson,
    bool actualizar = false,
  }) async {
    int bloque = 1;
    int numBloques = 0;

    try {
      // 1. Verificar si ya hay datos y no se fuerza actualización
      if (!actualizar) {
        final count = await countLocal();
        if (count > 0) {
          return true;
        }
      }

      // 2. Borrar datos existentes si es una actualización
      if (actualizar) {
        await deleteAll();
      }

      // 3. Descargar por bloques
      do {
        final response = await http.post(
          Uri.parse(
            'https://dev2.tarkus.app/multas/servicios/gestion_catalogo.json?'
            'token=${this.token}&catalogo=$nombreCatalogo&bloque=$bloque',
          ),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final registros = jsonResponse['registros'] as List;

          // Insertar registros en la DB
          for (final registro in registros) {
            await insert(fromJson(registro));
          }

          numBloques = jsonResponse['numbloques'] ?? 0;
          bloque++;
        } else {
          return false;
        }
      } while (bloque <= numBloques);

      return true;
    } catch (e) {
      // Fallback a datos locales
      final datosLocales = await getLocal();
      final count = await countLocal();
      return count > 0;
    }
  }

  // Métodos específicos para cada catálogo
  Future<bool> descargarCalles({bool actualizar = false}) =>
      _descargarCatalogo<Calle>(
        nombreCatalogo: 'calles',
        countLocal: dbHelper.countCalles,
        deleteAll: dbHelper.deleteAllCalles,
        insert: (calle) => dbHelper.insertCalle(calle),
        getLocal: dbHelper.getCalles,
        fromJson: Calle.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarColonias({bool actualizar = false}) =>
      _descargarCatalogo<Calle>(
        nombreCatalogo: 'colonias',
        countLocal: dbHelper.countColonias,
        deleteAll: dbHelper.deleteAllColonias,
        insert: (colonia) => dbHelper.insertColonia(colonia),
        getLocal: dbHelper.getColonias,
        fromJson: Calle.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarMarcas({bool actualizar = false}) =>
      _descargarCatalogo<Marcas>(
        nombreCatalogo: 'marcas',
        countLocal: dbHelper.countMarcas,
        deleteAll: dbHelper.deleteAllMarcas,
        insert: (marca) => dbHelper.insertMarca(marca),
        getLocal: dbHelper.getMarcas,
        fromJson: Marcas.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarSectores({bool actualizar = false}) =>
      _descargarCatalogo<Sectores>(
        nombreCatalogo: 'sectores',
        countLocal: dbHelper.countSectores,
        deleteAll: dbHelper.deleteAllSectores,
        insert: (sector) => dbHelper.insertSector(sector),
        getLocal: dbHelper.getSectores,
        fromJson: Sectores.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarUnidades({bool actualizar = false}) =>
      _descargarCatalogo<Unidades>(
        nombreCatalogo: 'unidades',
        countLocal: dbHelper.countUnidades,
        deleteAll: dbHelper.deleteAllUnidades,
        insert: (unidad) => dbHelper.insertUnidad(unidad),
        getLocal: dbHelper.getUnidades,
        fromJson: Unidades.fromJson,
        actualizar: actualizar,
      );

  // Método para descargar todos los catálogos
  Future<Map<String, bool>> descargarTodosCatalogos({
    bool actualizar = false,
  }) async {
    final resultados = <String, bool>{};

    resultados['calles'] = await descargarCalles(actualizar: actualizar);
    resultados['colonias'] = await descargarColonias(actualizar: actualizar);
    resultados['marcas'] = await descargarMarcas(actualizar: actualizar);
    resultados['sectores'] = await descargarSectores(actualizar: actualizar);
    resultados['unidades'] = await descargarUnidades(actualizar: actualizar);

    return resultados;
  }
}

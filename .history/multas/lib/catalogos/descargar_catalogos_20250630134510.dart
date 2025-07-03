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
      _descargarCatalogo<Colonias>(
        nombreCatalogo: 'colonias',
        countLocal: dbHelper.countColonias,
        deleteAll: dbHelper.deleteAllColonias,
        insert: (colonia) => dbHelper.insertColonia(colonia),
        getLocal: dbHelper.getColonias,
        fromJson: Colonias.fromJson,
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

  Future<bool> descargarDocumentos({bool actualizar = false}) =>
      _descargarCatalogo<Documentos>(
        nombreCatalogo: 'documentos',
        countLocal: dbHelper.countDocumentos,
        deleteAll: dbHelper.deleteAllDocumentos,
        insert: (documento) => dbHelper.insertDocumento(documento),
        getLocal: dbHelper.getDocumentos,
        fromJson: Documentos.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarEstaciones({bool actualizar = false}) =>
      _descargarCatalogo<Estaciones>(
        nombreCatalogo: 'estaciones',
        countLocal: dbHelper.countEstaciones,
        deleteAll: dbHelper.deleteAllEstaciones,
        insert: (estacion) => dbHelper.insertEstacion(estacion),
        getLocal: dbHelper.getEstaciones,
        fromJson: Estaciones.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarLotes({bool actualizar = false}) =>
      _descargarCatalogo<Lotes>(
        nombreCatalogo: 'lotes',
        countLocal: dbHelper.countLotes,
        deleteAll: dbHelper.deleteAllLotes,
        insert: (lote) => dbHelper.insertLote(lote),
        getLocal: dbHelper.getLotes,
        fromJson: Lotes.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarAgentes({bool actualizar = false}) =>
      _descargarCatalogo<Agentes>(
        nombreCatalogo: 'agentes',
        countLocal: dbHelper.countAgentes,
        deleteAll: dbHelper.deleteAllAgentes,
        insert: (agente) => dbHelper.insertAgente(agente),
        getLocal: dbHelper.getAgentes,
        fromJson: Agentes.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarEstados({bool actualizar = false}) =>
      _descargarCatalogo<Estados>(
        nombreCatalogo: 'estados',
        countLocal: dbHelper.countEstados,
        deleteAll: dbHelper.deleteAllEstados,
        insert: (estado) => dbHelper.insertEstado(estado),
        getLocal: dbHelper.getEstados,
        fromJson: Estados.fromJson,
        actualizar: actualizar,
      );

  Future<bool> descargarDepartamentos({bool actualizar = false}) =>
      _descargarCatalogo<Departamentos>(
        nombreCatalogo: 'departamentos',
        countLocal: dbHelper.countDepartamentos,
        deleteAll: dbHelper.deleteAllDepartamentos,
        insert: (departamento) => dbHelper.insertDepartamento(departamento),
        getLocal: dbHelper.getDepartamentos,
        fromJson: Departamentos.fromJson,
        actualizar: actualizar,
      );

  // FALTA: Ciudades, Costos, Submarcas, Motivos
  Future<bool> descargarCiudades({bool actualizar = false}) =>
      _descargarCatalogo<Ciudades>(
        nombreCatalogo: 'ciudades',
        countLocal: dbHelper.countCiudades,
        deleteAll: dbHelper.deleteAllCiudades,
        insert: (ciudad) => dbHelper.insertCiudad(ciudad),
        getLocal: dbHelper.getCiudades,
        fromJson: (json) => Ciudades(
          id: json['id'],
          clave: json['clave'],
          nombre: json['nombre'],
          estado: json['estado'], // Campo adicional
        ),
        actualizar: actualizar,
      );

  Future<bool> descargarCostos({bool actualizar = false}) =>
      _descargarCatalogo<Costos>(
        nombreCatalogo: 'costos',
        countLocal: dbHelper.countCostos,
        deleteAll: dbHelper.deleteAllCostos,
        insert: (costo) => dbHelper.insertCosto(costo),
        getLocal: dbHelper.getCostos,
        fromJson: (json) => Costos(
          id: json['id'],
          periodo: json['periodo'],
          servicioMedico: json['servicio_medico'],
          salarioMinimo: json['salario_minimo'],
          hospedaje: json['hospedaje'],
          hospedajeDoble: json['hospedaje_doble'],
          gruaSencilla: json['grua_sencilla'],
          gruaOperadora: json['grua_operadora'],
          gruaDoble: json['grua_doble'],
        ),
        actualizar: actualizar,
      );
  Future<bool> descargarSubmarcas({bool actualizar = false}) =>
      _descargarCatalogo<Submarcas>(
        nombreCatalogo: 'submarcas',
        countLocal: dbHelper.countSubmarcas,
        deleteAll: dbHelper.deleteAllSubmarcas,
        insert: (submarca) => dbHelper.insertSubmarca(submarca),
        getLocal: dbHelper.getSubmarcas,
        fromJson: (json) => Submarcas(
          id: json['id'],
          clave: json['clave'],
          nombre: json['nombre'],
          idmarca: json['marca'], // Relación con marcas
        ),
        actualizar: actualizar,
      );

  Future<bool> descargarMotivos({bool actualizar = false}) =>
      _descargarCatalogo<Motivos>(
        nombreCatalogo: 'motivos',
        countLocal: dbHelper.countMotivos,
        deleteAll: dbHelper.deleteAllMotivos,
        insert: (motivo) => dbHelper.insertMotivo(motivo),
        getLocal: dbHelper.getMotivos,
        fromJson: (json) => Motivos(
          id: json['id'],
          clave: json['clave'],
          nombre: json['nombre'],
          uma: json['uma'],
          descuento: json['descuento'],
          periodo_descuento: json['periodo_descuento'],
          peritos: json['peritos'],
          articulo: json['articulo'],
          fraccion: json['fraccion'],
          sancion: json['sancion'],
        ),
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
    resultados['documentos'] = await descargarDocumentos(
      actualizar: actualizar,
    );
    resultados['estaciones'] = await descargarEstaciones(
      actualizar: actualizar,
    );
    resultados['lotes'] = await descargarLotes(actualizar: actualizar);
    resultados['agentes'] = await descargarAgentes(actualizar: actualizar);
    resultados['estados'] = await descargarEstados(actualizar: actualizar);
    resultados['departamentos'] = await descargarDepartamentos(
      actualizar: actualizar,
    );

    return resultados;
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'multas.dart';
export 'db.dart';

// SELECT id, clave, nombre FROM agentes;
// SELECT id, fechahora, descripcion, status, datos, token FROM bitacora;
// SELECT id, clave, nombre FROM calles;
// SELECT id, clave, fecha, dias FROM catalogos;
// SELECT id, estado, clave, nombre FROM ciudades;
// SELECT id, clave, nombre FROM colonias;
// SELECT id, clave, valor, descripcion FROM configuracion;
// SELECT id, periodo, servicio_medico, salario_minimo, hospedaje, hospedaje_doble, grua_sencilla, grua_operadora, grua_doble FROM costos;
// SELECT id, clave, nombre FROM departamentos;
// SELECT id, clave, nombre FROM documentos;
// SELECT id, clave, nombre FROM estaciones;
// SELECT id, clave, nombre FROM estados;
// SELECT id, idsesion, inicial, "final", actual FROM folios;
// SELECT id, infraccion, agente, fecha, placas, estado, municipio, calle_infraccion, calle_infraccion2, unidad, departamento, estacion,
// sector, licencia, lic_origen, documento, gps, observaciones, expediente, examen, status, ausente, idsesion, paso1, paso2, paso3, paso4, fechafin, statussaot, foliocaja FROM infraccion;
// SELECT id, idinfraccion, infraccion, importe, idinfraccionrel FROM infraccionadeudos;
// SELECT id, idinfraccion, nombre, apaterno, amaterno, edad, genero, domicilio, numext, numint, colonia, codigo_postal, telefono FROM infraccionconductor;
// SELECT id, idinfraccion, clave, importe FROM infraccionimportes;
// SELECT id, idinfraccion, motivo, uma, importe, descuento, periodo_descuento FROM infraccionmotivos;
// SELECT id, idpago, idinfraccion, importe, infraccion FROM infraccionpagos;
// SELECT id, idinfraccion, gruaschicas, gruasgrandes, lote, inventario FROM infraccionretencion;
// SELECT id, idinfraccion, marca, submarca, modelo, color, extranjero FROM infraccionvehiculo;
// SELECT id, clave, nombre FROM lotes;
// SELECT id, clave, nombre FROM marcas;
// SELECT id, clave, nombre, uma, descuento, periodo_descuento, peritos, articulo, fraccion, sancion FROM motivos;
// SELECT id, respuesta, autorizacion, cfolio, orderid, fecha_hora, total, status FROM pagos;
// SELECT id, clave, valor, descripcion FROM parametros;
// SELECT id, clave, nombre FROM sectores;
// SELECT id, status, fechahora, clave, nombre, contrasena, token, mensaje FROM sesion;
// SELECT id, clave, nombre, marca FROM submarcas;
// SELECT id, clave, nombre FROM unidades;
// SELECT id, infraccion, agente, fecha, placas, estado, municipio, calle_infraccion, calle_infraccion2, unidad, departamento, estacion, sector, licencia, lic_origen, documento, expediente,
// gps, observaciones, examen, status, statussaot, ausente, idsesion, paso1, paso2, paso3, paso4, fechafin, foliocaja, nombre, apaterno, amaterno, edad, genero, domicilio, numint, numext,
// colonia, codigo_postal, telefono, marca, submarca, modelo, color, extranjero, idretencion, gruaschicas, gruasgrandes, lote, inventario, idpago, autorizacion, cfolio, orderid, fechapago,
// monto, monto_total, "subtotal::FLOAT", "descuento::FLOAT", "periodo_descuento::INTEGER", "recargo::FLOAT", "adeudo::FLOAT", agente_nombre FROM vinfraccion;
// SELECT id, idinfraccion, importe, descuento, periodo_descuento, clave, nombre, articulo, fraccion, sancion, uma, descuento_porcentaje, infraccion, idsesion, status FROM vmotivos;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'multas.db'),
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE agentes(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        await db.execute('''
  CREATE TABLE bitacora(
    id INTEGER PRIMARY KEY,
    fechahora TEXT,
    descripcion TEXT,
    status TEXT,
    datos TEXT,
    token TEXT
  )
''');

        await db.execute('''
  CREATE TABLE calles(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        await db.execute('''
  CREATE TABLE catalogos(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    fecha TEXT,
    dias TEXT
  )
''');

        // Tabla Ciudades
        await db.execute('''
  CREATE TABLE ciudades(
    id INTEGER PRIMARY KEY,
    estado TEXT,
    clave TEXT,
    nombre TEXT
  )
''');

        // Tabla Colonias
        await db.execute('''
  CREATE TABLE colonias(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        // Tabla Configuración
        await db.execute('''
  CREATE TABLE IF NOT EXISTS configuracion(
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    valor TEXT NOT NULL,
    descripcion TEXT
  )
''');

        // Tabla Costos
        await db.execute('''
  CREATE TABLE IF NOT EXISTS costos(
    id INTEGER PRIMARY KEY,
    periodo INTEGER NOT NULL UNIQUE,
    servicio_medico REAL NOT NULL,
    salario_minimo REAL NOT NULL,
    hospedaje REAL NOT NULL,
    hospedaje_doble REAL NOT NULL,
    grua_sencilla REAL NOT NULL,
    grua_operadora REAL NOT NULL,
    grua_doble REAL NOT NULL
  )
''');
      },
      version: 1,
    );
  }

  // Función para insertar
  Future<void> insertAgente(Agentes agente) async {
    final Database db = await database;
    await db.insert(
      'agentes',
      agente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Función para obtener todos
  Future<List<Agentes>> getAllAgentes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('agentes');
    return List.generate(maps.length, (i) {
      return Agentes.fromMap(maps[i]);
    });
  }

  // Función para insertar
  Future<void> insertBitacora(Bitacora bitacora) async {
    final Database db = await database;
    await db.insert('bitacora', {
      'id': bitacora.id,
      'fechahora': bitacora.fechahora?.toIso8601String(),
      'descripcion': bitacora.descripcion,
      'status': bitacora.status,
      'datos': bitacora.datos,
      'token': bitacora.token,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Función para obtener todos
  Future<List<Bitacora>> getAllBitacora() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bitacora');
    return List.generate(maps.length, (i) {
      return Bitacora.fromMap({
        'id': maps[i]['id'],
        'fechahora': maps[i]['fechahora'] != null
            ? DateTime.parse(maps[i]['fechahora'])
            : null,
        'descripcion': maps[i]['descripcion'],
        'status': maps[i]['status'],
        'datos': maps[i]['datos'],
        'token': maps[i]['token'],
      });
    });
  }

  // Función para insertar
  Future<void> insertCalle(Calles calle) async {
    final Database db = await database;
    await db.insert(
      'calles',
      calle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Función para obtener todos
  Future<List<Calles>> getAllCalles() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calles');
    return List.generate(maps.length, (i) {
      return Calles.fromMap(maps[i]);
    });
  }

  // Función para insertar
  Future<void> insertCatalogo(Catalogos catalogo) async {
    final Database db = await database;
    await db.insert(
      'catalogos',
      catalogo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Función para obtener todos
  Future<List<Catalogos>> getAllCatalogos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('catalogos');
    return List.generate(maps.length, (i) {
      return Catalogos.fromMap(maps[i]);
    });
  }

  // ========== FUNCIONES PARA CIUDADES ==========

  // Insertar nueva ciudad
  Future<void> insertCiudad(Ciudades ciudad) async {
    final Database db = await database;
    await db.insert(
      'ciudades',
      ciudad.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las ciudades
  Future<List<Ciudades>> getAllCiudades() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ciudades');
    return List.generate(maps.length, (i) {
      return Ciudades.fromMap(maps[i]);
    });
  }

  // ========== FUNCIONES PARA COLONIAS ==========

  // Insertar nueva colonia
  Future<void> insertColonia(Colonias colonia) async {
    final Database db = await database;
    await db.insert(
      'colonias',
      colonia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las colonias
  Future<List<Colonias>> getAllColonias() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('colonias');
    return List.generate(maps.length, (i) {
      return Colonias.fromMap(maps[i]);
    });
  }
}

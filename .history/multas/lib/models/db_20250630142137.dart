import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'multas.dart';
export 'db.dart';

// SELECT id, fechahora, descripcion, status, datos, token FROM bitacora;

// SELECT id, clave, nombre FROM calles;
// SELECT id, clave, nombre FROM colonias;

// SELECT id, clave, nombre FROM agentes;
// SELECT id, clave, nombre FROM estados;
// SELECT id, clave, nombre FROM departamentos;
// SELECT id, clave, nombre FROM documentos;
// SELECT id, clave, nombre FROM estaciones;
// SELECT id, clave, nombre FROM lotes;
// SELECT id, clave, nombre FROM marcas;
// SELECT id, clave, nombre FROM sectores;
// SELECT id, clave, nombre FROM unidades;

// SELECT id, estado, clave, nombre FROM ciudades;
// SELECT id, periodo, servicio_medico, salario_minimo, hospedaje, hospedaje_doble, grua_sencilla, grua_operadora, grua_doble FROM costos;
// SELECT id, clave, nombre, marca FROM submarcas;
// SELECT id, clave, nombre, uma, descuento, periodo_descuento, peritos, articulo, fraccion, sancion FROM motivos;

// SELECT id, clave, fecha, dias FROM catalogos;

// SELECT id, clave, valor, descripcion FROM configuracion;

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

// SELECT id, respuesta, autorizacion, cfolio, orderid, fecha_hora, total, status FROM pagos;
// SELECT id, clave, valor, descripcion FROM parametros;

// SELECT id, status, fechahora, clave, nombre, contrasena, token, mensaje FROM sesion;

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

        // Tabla Departamentos
        await db.execute('''
  CREATE TABLE Departamentos(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        // Tabla Documentos
        await db.execute('''
  CREATE TABLE Documentos(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        // Tabla Estaciones
        await db.execute('''
  CREATE TABLE estaciones(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        await db.execute('''
  CREATE TABLE estados(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        await db.execute('''
  CREATE TABLE folios(
    id INTEGER PRIMARY KEY,
    idsesion TEXT,
    inicial TEXT,
    final TEXT,
    actual TEXT
  )
''');

        // ========== CREACIÓN DE TABLA ==========
        await db.execute('''
  CREATE TABLE infraccion(
    id INTEGER PRIMARY KEY,
    infraccion TEXT,
    agente TEXT,
    fecha TEXT,
    placas TEXT,
    estado TEXT,
    municipio TEXT,
    calle_infraccion TEXT,
    calle_infraccion2 TEXT,
    unidad TEXT,
    departamento TEXT,
    estacion TEXT,
    sector TEXT,
    licencia TEXT,
    lic_origen TEXT,
    documento TEXT,
    gps TEXT,
    observaciones TEXT,
    expediente TEXT,
    examen TEXT,
    status TEXT,
    ausente TEXT,
    idsesion TEXT,
    paso1 TEXT,
    paso2 TEXT,
    paso3 TEXT,
    paso4 TEXT,
    fechafin TEXT,
    statussaot TEXT,
    foliocaja TEXT
  )
''');

        await db.execute('''
  CREATE TABLE infraccionadeudos(
    id INTEGER PRIMARY KEY,
    idinfraccion TEXT,
    infraccion TEXT,
    importe REAL,
    idinfraccionrel TEXT
  )
''');

        await db.execute('''
  CREATE TABLE infraccionconductor(
    id INTEGER PRIMARY KEY,
    idinfraccion TEXT,
    nombre TEXT,
    apaterno TEXT,
    amaterno TEXT,
    edad TEXT,
    genero TEXT,
    domicilio TEXT,
    numext TEXT,
    numint TEXT,
    colonia TEXT,
    codigo_postal TEXT,
    telefono TEXT
  )
''');

        await db.execute('''
  CREATE TABLE infraccionimportes(
    id INTEGER PRIMARY KEY,
    idinfraccion TEXT,
    clave TEXT,
    importe REAL
  )
''');

        await db.execute('''
  CREATE TABLE infraccionmotivos(
    id INTEGER PRIMARY KEY,
    idinfraccion TEXT,
    motivo TEXT,
    uma TEXT,
    importe REAL,
    descuento TEXT,
    periodo_descuento TEXT
  )
''');

        await db.execute('''
  CREATE TABLE infraccionpagos(
    id INTEGER PRIMARY KEY,
    idpago TEXT,
    idinfraccion TEXT,
    importe REAL,
    infraccion TEXT
  )
''');

        await db.execute('''
  CREATE TABLE infraccionretencion(
    id INTEGER PRIMARY KEY,
    idinfraccion TEXT,
    gruaschicas TEXT,
    gruasgrandes TEXT,
    lote TEXT,
    inventario TEXT
  )
''');

        await db.execute('''
  CREATE TABLE infraccionvehiculo(
    id INTEGER PRIMARY KEY,
    idinfraccion TEXT,
    marca TEXT,
    submarca TEXT,
    modelo TEXT,
    color TEXT,
    extranjero TEXT
  )
''');

        await db.execute('''
  CREATE TABLE lotes(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        await db.execute('''
  CREATE TABLE marcas(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        await db.execute('''
  CREATE TABLE motivos(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT,
    uma REAL,
    descuento REAL,
    periodo_descuento REAL,
    peritos INTEGER,  -- Se almacena como 0 o 1 (SQLite no tiene tipo BOOLEAN)
    articulo TEXT,
    fraccion TEXT,
    sancion TEXT
  )
''');

        await db.execute('''
  CREATE TABLE pagos(
    id INTEGER PRIMARY KEY,
    respuesta TEXT,
    autorizacion TEXT,
    cfolio TEXT,
    orderid TEXT,
    fecha_hora TEXT,  -- Almacenado como texto ISO8601
    total REAL,
    status TEXT
  )
''');

        await db.execute('''
  CREATE TABLE parametros(
    id INTEGER PRIMARY KEY,
    clave TEXT UNIQUE,
    valor TEXT,
    descripcion TEXT
  )
''');

        await db.execute('''
  CREATE TABLE sectores(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');

        await db.execute('''
  CREATE TABLE sesion(
    id INTEGER PRIMARY KEY,
    status INTEGER,  -- Se almacena como 0 o 1 (SQLite no tiene tipo BOOLEAN)
    fechahora TEXT,  -- Almacenado como texto ISO8601
    clave TEXT,
    nombre TEXT,
    contrasena TEXT,
    token TEXT,
    mensaje TEXT
  )
''');

        await db.execute('''
  CREATE TABLE submarcas (
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT,
    idmarca INTEGER,
    FOREIGN KEY (idmarca) REFERENCES marcas(id)
  )
''');

        await db.execute('''
  CREATE TABLE unidades(
    id INTEGER PRIMARY KEY,
    clave TEXT,
    nombre TEXT
  )
''');
      },
      version: 1,
    );
  }

  // ========== FUNCIONES PARA SESIÓN ==========
  Future<void> insertSesion(Sesion sesion) async {
    final db = await database;
    await db.insert(
      'sesion',
      sesion.toMap(), // Usamos toMap() directamente
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Sesion>> getAllSesiones() async {
    final db = await database;
    final maps = await db.query('sesion');
    return List.generate(maps.length, (i) => Sesion.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA PAGOS ==========
  Future<void> insertPago(Pagos pago) async {
    final db = await database;
    await db.insert(
      'pagos',
      pago.toMap(), // Ya usa ISO8601 automáticamente
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pagos>> getAllPagos() async {
    final db = await database;
    final maps = await db.query('pagos');
    return List.generate(maps.length, (i) => Pagos.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA PARAMETROS ==========
  Future<void> insertParametro(Parametros parametro) async {
    final db = await database;
    await db.insert(
      'parametros',
      parametro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Parametros>> getAllParametros() async {
    final db = await database;
    final maps = await db.query('parametros');
    return List.generate(maps.length, (i) => Parametros.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA MOTIVOS ==========
  // Future<void> insertMotivo(Motivos motivo) async {
  //   final db = await database;
  //   await db.insert('motivos', {
  //     'id': motivo.id,
  //     'clave': motivo.clave,
  //     'nombre': motivo.nombre,
  //     'uma': motivo.uma,
  //     'descuento': motivo.descuento,
  //     'periodo_descuento': motivo.periodo_descuento,
  //     'peritos': motivo.peritos != null ? (motivo.peritos! ? 1 : 0) : null,
  //     'articulo': motivo.articulo,
  //     'fraccion': motivo.fraccion,
  //     'sancion': motivo.sancion,
  //   }, conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future<List<Motivos>> getAllMotivos() async {
  //   final db = await database;
  //   final maps = await db.query('motivos');
  //   return List.generate(maps.length, (i) {
  //     return Motivos.fromMap({
  //       'id': maps[i]['id'],
  //       'clave': maps[i]['clave'],
  //       'nombre': maps[i]['nombre'],
  //       'uma': maps[i]['uma'],
  //       'descuento': maps[i]['descuento'],
  //       'periodo_descuento': maps[i]['periodo_descuento'],
  //       'peritos': maps[i]['peritos'] == 1, // Convertir a booleano
  //       'articulo': maps[i]['articulo'],
  //       'fraccion': maps[i]['fraccion'],
  //       'sancion': maps[i]['sancion'],
  //     });
  //   });
  // }

  // ========== FUNCIONES PARA INFRACCIÓN RETENCIÓN ==========
  Future<void> insertInfraccionRetencion(Infraccionretencion retencion) async {
    final db = await database;
    await db.insert(
      'infraccionretencion',
      retencion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Infraccionretencion>> getAllInfraccionRetenciones() async {
    final db = await database;
    final maps = await db.query('infraccionretencion');
    return List.generate(
      maps.length,
      (i) => Infraccionretencion.fromMap(maps[i]),
    );
  }

  // ========== FUNCIONES PARA INFRACCIÓN VEHÍCULO ==========
  Future<void> insertInfraccionVehiculo(Infraccionvehiculo vehiculo) async {
    final db = await database;
    await db.insert(
      'infraccionvehiculo',
      vehiculo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Infraccionvehiculo>> getAllInfraccionVehiculos() async {
    final db = await database;
    final maps = await db.query('infraccionvehiculo');
    return List.generate(
      maps.length,
      (i) => Infraccionvehiculo.fromMap(maps[i]),
    );
  }

  // ========== FUNCIONES PARA INFRACCIÓN IMPORTES ==========
  Future<void> insertInfraccionImporte(InfraccionImportes importe) async {
    final db = await database;
    await db.insert(
      'infraccionimportes',
      importe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InfraccionImportes>> getAllInfraccionImportes() async {
    final db = await database;
    final maps = await db.query('infraccionimportes');
    return List.generate(
      maps.length,
      (i) => InfraccionImportes.fromMap(maps[i]),
    );
  }

  // ========== FUNCIONES PARA INFRACCIÓN MOTIVOS ==========
  Future<void> insertInfraccionMotivo(InfraccionMotivos motivo) async {
    final db = await database;
    await db.insert(
      'infraccionmotivos',
      motivo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InfraccionMotivos>> getAllInfraccionMotivos() async {
    final db = await database;
    final maps = await db.query('infraccionmotivos');
    return List.generate(
      maps.length,
      (i) => InfraccionMotivos.fromMap(maps[i]),
    );
  }

  // ========== FUNCIONES PARA INFRACCIÓN PAGOS ==========
  Future<void> insertInfraccionPago(InfraccionPagos pago) async {
    final db = await database;
    await db.insert(
      'infraccionpagos',
      pago.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InfraccionPagos>> getAllInfraccionPagos() async {
    final db = await database;
    final maps = await db.query('infraccionpagos');
    return List.generate(maps.length, (i) => InfraccionPagos.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA INFRACCIÓN ADEUDOS ==========
  Future<void> insertInfraccionAdeudo(InfraccionAdeudos adeudo) async {
    final db = await database;
    await db.insert(
      'infraccionadeudos',
      adeudo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InfraccionAdeudos>> getAllInfraccionAdeudos() async {
    final db = await database;
    final maps = await db.query('infraccionadeudos');
    return List.generate(
      maps.length,
      (i) => InfraccionAdeudos.fromMap(maps[i]),
    );
  }

  // ========== FUNCIONES PARA INFRACCIÓN CONDUCTOR ==========
  Future<void> insertInfraccionConductor(InfraccionConductor conductor) async {
    final db = await database;
    await db.insert(
      'infraccionconductor',
      conductor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InfraccionConductor>> getAllInfraccionConductores() async {
    final db = await database;
    final maps = await db.query('infraccionconductor');
    return List.generate(
      maps.length,
      (i) => InfraccionConductor.fromMap(maps[i]),
    );
  }

  // ========== FUNCIONES PARA INFRACCIÓN ==========
  Future<void> insertInfraccion(Infraccion infraccion) async {
    final db = await database;
    await db.insert(
      'infraccion',
      infraccion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Infraccion>> getAllInfracciones() async {
    final db = await database;
    final maps = await db.query('infraccion');
    return List.generate(maps.length, (i) => Infraccion.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA FOLIOS ==========
  Future<void> insertFolio(Folios folio) async {
    final db = await database;
    await db.insert(
      'folios',
      folio.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Folios>> getAllFolios() async {
    final db = await database;
    final maps = await db.query('folios');
    return List.generate(maps.length, (i) => Folios.fromMap(maps[i]));
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

  //  ========== FUNCIONES PARA CALLES ==========
  // Insertar una calle
  Future<int> insertCalle(Calle calle) async {
    final db = await database;
    return await db.insert('calles', calle.toMap());
  }

  // Obtener todas las calles
  Future<List<Calle>> getCalles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calles');
    return List.generate(maps.length, (i) => Calle.fromMap(maps[i]));
  }

  Future<List<Calle>> buscarCalles(String query) async {
    final db = await database;
    final results = await db.query(
      'calles',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6, // Limitar resultados para mejor performance
    );
    return results.map((e) => Calle.fromJson(e)).toList();
  }

  // Eliminar todas las calles
  Future<int> deleteAllCalles() async {
    final db = await database;
    return await db.delete('calles');
  }

  // Contar calles
  Future<int> countCalles() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM calles'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA COLONIAS ==========

  // Insertar nueva colonia
  // Función para insertar COLONIAS
  Future<int> insertColonia(Colonias colonias) async {
    final db = await database;
    return await db.insert('colonias', colonias.toMap());
  }

  // Obtener todas las colonias
  Future<List<Colonias>> getColonias() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('colonias');
    return List.generate(maps.length, (i) => Colonias.fromMap(maps[i]));
  }

  Future<List<Colonias>> buscarColonias(String query) async {
    final db = await database;
    final results = await db.query(
      'colonias',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6, // Limitar resultados para mejor performance
    );
    return results.map((e) => Colonias.fromJson(e)).toList();
  }

  // Eliminar todas las colonias
  Future<int> deleteAllColonias() async {
    final db = await database;
    return await db.delete('colonias');
  }

  // Contar colonias
  Future<int> countColonias() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM colonias'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA AGENTES ==========

  // Insertar un agente
  Future<int> insertAgente(Agentes agente) async {
    final db = await database;
    return await db.insert('agentes', agente.toMap());
  }

  // Obtener todos los agentes
  Future<List<Agentes>> getAgentes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('agentes');
    return List.generate(maps.length, (i) => Agentes.fromMap(maps[i]));
  }

  Future<List<Agentes>> buscarAgentes(String query) async {
    final db = await database;
    final results = await db.query(
      'agentes',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Agentes.fromJson(e)).toList();
  }

  // Eliminar todos los agentes
  Future<int> deleteAllAgentes() async {
    final db = await database;
    return await db.delete('agentes');
  }

  // Contar agentes
  Future<int> countAgentes() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM agentes'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA ESTADOS ==========

  // Insertar un estado
  Future<int> insertEstado(Estados estado) async {
    final db = await database;
    return await db.insert('estados', estado.toMap());
  }

  // Obtener todos los estados
  Future<List<Estados>> getEstados() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('estados');
    return List.generate(maps.length, (i) => Estados.fromMap(maps[i]));
  }

  Future<List<Estados>> buscarEstados(String query) async {
    final db = await database;
    final results = await db.query(
      'estados',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Estados.fromJson(e)).toList();
  }

  // Eliminar todos los estados
  Future<int> deleteAllEstados() async {
    final db = await database;
    return await db.delete('estados');
  }

  // Contar estados
  Future<int> countEstados() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM estados'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA DEPARTAMENTOS ==========

  // Insertar un departamento
  Future<int> insertDepartamento(Departamentos departamento) async {
    final db = await database;
    return await db.insert('departamentos', departamento.toMap());
  }

  // Obtener todos los departamentos
  Future<List<Departamentos>> getDepartamentos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('departamentos');
    return List.generate(maps.length, (i) => Departamentos.fromMap(maps[i]));
  }

  Future<List<Departamentos>> buscarDepartamentos(String query) async {
    final db = await database;
    final results = await db.query(
      'departamentos',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Departamentos.fromJson(e)).toList();
  }

  // Eliminar todos los departamentos
  Future<int> deleteAllDepartamentos() async {
    final db = await database;
    return await db.delete('departamentos');
  }

  // Contar departamentos
  Future<int> countDepartamentos() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM departamentos'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA DOCUMENTOS ==========

  // Insertar un documento
  Future<int> insertDocumento(Documentos documento) async {
    final db = await database;
    return await db.insert('documentos', documento.toMap());
  }

  // Obtener todos los documentos
  Future<List<Documentos>> getDocumentos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('documentos');
    return List.generate(maps.length, (i) => Documentos.fromMap(maps[i]));
  }

  Future<List<Documentos>> buscarDocumentos(String query) async {
    final db = await database;
    final results = await db.query(
      'documentos',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Documentos.fromJson(e)).toList();
  }

  // Eliminar todos los documentos
  Future<int> deleteAllDocumentos() async {
    final db = await database;
    return await db.delete('documentos');
  }

  // Contar documentos
  Future<int> countDocumentos() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM documentos'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA ESTACIONES ==========

  // Insertar una estación
  Future<int> insertEstacion(Estaciones estacion) async {
    final db = await database;
    return await db.insert('estaciones', estacion.toMap());
  }

  // Obtener todas las estaciones
  Future<List<Estaciones>> getEstaciones() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('estaciones');
    return List.generate(maps.length, (i) => Estaciones.fromMap(maps[i]));
  }

  Future<List<Estaciones>> buscarEstaciones(String query) async {
    final db = await database;
    final results = await db.query(
      'estaciones',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Estaciones.fromJson(e)).toList();
  }

  // Eliminar todas las estaciones
  Future<int> deleteAllEstaciones() async {
    final db = await database;
    return await db.delete('estaciones');
  }

  // Contar estaciones
  Future<int> countEstaciones() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM estaciones'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA LOTES ==========

  // Insertar un lote
  Future<int> insertLote(Lotes lote) async {
    final db = await database;
    return await db.insert('lotes', lote.toMap());
  }

  // Obtener todos los lotes
  Future<List<Lotes>> getLotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('lotes');
    return List.generate(maps.length, (i) => Lotes.fromMap(maps[i]));
  }

  Future<List<Lotes>> buscarLotes(String query) async {
    final db = await database;
    final results = await db.query(
      'lotes',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Lotes.fromJson(e)).toList();
  }

  // Eliminar todos los lotes
  Future<int> deleteAllLotes() async {
    final db = await database;
    return await db.delete('lotes');
  }

  // Contar lotes
  Future<int> countLotes() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM lotes'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA MARCAS ==========

  // Insertar una marca
  Future<int> insertMarca(Marcas marca) async {
    final db = await database;
    return await db.insert(
      'marcas',
      marca.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Esto sobrescribirá si el ID existe
    );
  }

  // Obtener todas las marcas
  Future<List<Marcas>> getMarcas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('marcas');
    return List.generate(maps.length, (i) => Marcas.fromMap(maps[i]));
  }

  Future<List<Marcas>> buscarMarcas(String query) async {
    final db = await database;
    final results = await db.query(
      'marcas',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Marcas.fromJson(e)).toList();
  }

  // Eliminar todas las marcas
  Future<int> deleteAllMarcas() async {
    final db = await database;
    return await db.delete('marcas');
  }

  // Contar marcas
  Future<int> countMarcas() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM marcas'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA SECTORES ==========

  // Insertar un sector
  Future<int> insertSector(Sectores sector) async {
    final db = await database;
    return await db.insert('sectores', sector.toMap());
  }

  // Obtener todos los sectores
  Future<List<Sectores>> getSectores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sectores');
    return List.generate(maps.length, (i) => Sectores.fromMap(maps[i]));
  }

  Future<List<Sectores>> buscarSectores(String query) async {
    final db = await database;
    final results = await db.query(
      'sectores',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Sectores.fromJson(e)).toList();
  }

  // Eliminar todos los sectores
  Future<int> deleteAllSectores() async {
    final db = await database;
    return await db.delete('sectores');
  }

  // Contar sectores
  Future<int> countSectores() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM sectores'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA UNIDADES ==========

  // Insertar una unidad
  Future<int> insertUnidad(Unidades unidad) async {
    final db = await database;
    return await db.insert('unidades', unidad.toMap());
  }

  // Obtener todas las unidades
  Future<List<Unidades>> getUnidades() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('unidades');
    return List.generate(maps.length, (i) => Unidades.fromMap(maps[i]));
  }

  Future<List<Unidades>> buscarUnidades(String query) async {
    final db = await database;
    final results = await db.query(
      'unidades',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
      limit: 6,
    );
    return results.map((e) => Unidades.fromJson(e)).toList();
  }

  // Eliminar todas las unidades
  Future<int> deleteAllUnidades() async {
    final db = await database;
    return await db.delete('unidades');
  }

  // Contar unidades
  Future<int> countUnidades() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM unidades'),
        ) ??
        0;
  }

  // ========== FUNCIONES PARA CATALOGOS ==========

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

  // Contar ciudades
  Future<int> countCiudades() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM ciudades'),
        ) ??
        0;
  }

  // Eliminar todas las ciudades
  Future<int> deleteAllCiudades() async {
    final db = await database;
    return await db.delete('ciudades');
  }

  // Insertar ciudad
  Future<int> insertCiudad(Ciudades ciudad) async {
    final db = await database;
    return await db.insert('ciudades', ciudad.toMap());
  }

  // Obtener todas las ciudades
  Future<List<Ciudades>> getCiudades() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ciudades');
    return List.generate(maps.length, (i) => Ciudades.fromMap(maps[i]));
  }

  // Contar costos
  Future<int> countCostos() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM costos'),
        ) ??
        0;
  }

  // Eliminar todos los costos
  Future<int> deleteAllCostos() async {
    final db = await database;
    return await db.delete('costos');
  }

  // Insertar costo
  Future<int> insertCosto(Costos costo) async {
    final db = await database;
    return await db.insert('costos', costo.toMap());
  }

  // Obtener todos los costos
  Future<List<Costos>> getCostos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('costos');
    return List.generate(maps.length, (i) => Costos.fromMap(maps[i]));
  }

  // Contar submarcas

  Future<List<Submarcas>> buscarSubMarcas(String query, String id_marca) async {
    final db = await database;
    final results = await db.query(
      'submarcas',
      where: 'idmarca=? and nombre LIKE ?',
      whereArgs: ['$id_marca', '%$query%'],
      limit: 6,
    );
    return results.map((e) => Submarcas.fromJson(e)).toList();
  }

  Future<int> countSubmarcas() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM submarcas'),
        ) ??
        0;
  }

  // Eliminar todas las submarcas
  Future<int> deleteAllSubmarcas() async {
    final db = await database;
    return await db.delete('submarcas');
  }

  // Insertar submarca
  Future<int> insertSubmarca(Submarcas submarca) async {
    final db = await database;
    return await db.insert(
      'submarcas',
      submarca.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las submarcas
  Future<List<Submarcas>> getSubmarcas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('submarcas');
    return List.generate(maps.length, (i) => Submarcas.fromMap(maps[i]));
  }

  // Contar motivos
  Future<int> countMotivos() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM motivos'),
        ) ??
        0;
  }

  // Eliminar todos los motivos
  Future<int> deleteAllMotivos() async {
    final db = await database;
    return await db.delete('motivos');
  }

  // Insertar motivo
  Future<int> insertMotivo(Motivos motivo) async {
    final db = await database;
    return await db.insert('motivos', motivo.toMap());
  }

  // Obtener todos los motivos
  Future<List<Motivos>> getMotivos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('motivos');
    return List.generate(maps.length, (i) => Motivos.fromMap(maps[i]));
  }
  // ===== CONFIGURACIÓN ===== //

  // Insertar configuración
  Future<void> insertConfiguracion(Configuracion config) async {
    final db = await database;
    await db.insert(
      'configuracion',
      config.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener toda la configuración
  Future<List<Configuracion>> getAllConfiguracion() async {
    final db = await database;
    final maps = await db.query('configuracion');
    return List.generate(maps.length, (i) => Configuracion.fromMap(maps[i]));
  }
}

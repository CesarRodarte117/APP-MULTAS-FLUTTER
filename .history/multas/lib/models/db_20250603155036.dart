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
      },
      version: 1,
    );
  }

  // ========== FUNCIONES PARA PAGOS ==========
  Future<void> insertPago(Pagos pago) async {
    final db = await database;
    await db.insert('pagos', {
      'id': pago.id,
      'respuesta': pago.respuesta,
      'autorizacion': pago.autorizacion,
      'cfolio': pago.cfolio,
      'orderid': pago.orderid,
      'fecha_hora': pago.fecha_hora?.toIso8601String(),
      'total': pago.total,
      'status': pago.status,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pagos>> getAllPagos() async {
    final db = await database;
    final maps = await db.query('pagos');
    return List.generate(maps.length, (i) {
      return Pagos.fromMap({
        'id': maps[i]['id'],
        'respuesta': maps[i]['respuesta'],
        'autorizacion': maps[i]['autorizacion'],
        'cfolio': maps[i]['cfolio'],
        'orderid': maps[i]['orderid'],
        'fecha_hora': maps[i]['fecha_hora'] != null
            ? DateTime.parse(maps[i]['fecha_hora'])
            : null,
        'total': maps[i]['total'],
        'status': maps[i]['status'],
      });
    });
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

  // ========== FUNCIONES PARA SECTORES ==========
  Future<void> insertSector(Sectores sector) async {
    final db = await database;
    await db.insert(
      'sectores',
      sector.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Sectores>> getAllSectores() async {
    final db = await database;
    final maps = await db.query('sectores');
    return List.generate(maps.length, (i) => Sectores.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA LOTES ==========
  Future<void> insertLote(Lotes lote) async {
    final db = await database;
    await db.insert(
      'lotes',
      lote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Lotes>> getAllLotes() async {
    final db = await database;
    final maps = await db.query('lotes');
    return List.generate(maps.length, (i) => Lotes.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA MARCAS ==========
  Future<void> insertMarca(Marcas marca) async {
    final db = await database;
    await db.insert(
      'marcas',
      marca.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Marcas>> getAllMarcas() async {
    final db = await database;
    final maps = await db.query('marcas');
    return List.generate(maps.length, (i) => Marcas.fromMap(maps[i]));
  }

  // ========== FUNCIONES PARA MOTIVOS ==========
  Future<void> insertMotivo(Motivos motivo) async {
    final db = await database;
    await db.insert('motivos', {
      'id': motivo.id,
      'clave': motivo.clave,
      'nombre': motivo.nombre,
      'uma': motivo.uma,
      'descuento': motivo.descuento,
      'periodo_descuento': motivo.periodo_descuento,
      'peritos': motivo.peritos != null ? (motivo.peritos! ? 1 : 0) : null,
      'articulo': motivo.articulo,
      'fraccion': motivo.fraccion,
      'sancion': motivo.sancion,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Motivos>> getAllMotivos() async {
    final db = await database;
    final maps = await db.query('motivos');
    return List.generate(maps.length, (i) {
      return Motivos.fromMap({
        'id': maps[i]['id'],
        'clave': maps[i]['clave'],
        'nombre': maps[i]['nombre'],
        'uma': maps[i]['uma'],
        'descuento': maps[i]['descuento'],
        'periodo_descuento': maps[i]['periodo_descuento'],
        'peritos': maps[i]['peritos'] == 1, // Convertir a booleano
        'articulo': maps[i]['articulo'],
        'fraccion': maps[i]['fraccion'],
        'sancion': maps[i]['sancion'],
      });
    });
  }

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

  // ========== FUNCIONES PARA ESTADOS ==========
  Future<void> insertEstado(Estados estado) async {
    final db = await database;
    await db.insert(
      'estados',
      estado.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Estados>> getAllEstados() async {
    final db = await database;
    final maps = await db.query('estados');
    return List.generate(maps.length, (i) => Estados.fromMap(maps[i]));
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

  // ===== ESTACIONES ===== //

  // Insertar estación
  Future<void> insertEstacion(Estaciones estacion) async {
    final db = await database;
    await db.insert(
      'estaciones',
      estacion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las estaciones
  Future<List<Estaciones>> getAllEstaciones() async {
    final db = await database;
    final maps = await db.query('estaciones');
    return List.generate(maps.length, (i) => Estaciones.fromMap(maps[i]));
  }

  // ===== DOCUMENTOS ===== //

  // Insertar documento
  Future<void> insertDocumento(Documentos documento) async {
    final db = await database;
    await db.insert(
      'Documentos',
      documento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los documentos
  Future<List<Documentos>> getAllDocumentos() async {
    final db = await database;
    final maps = await db.query('Documentos');
    return List.generate(maps.length, (i) => Documentos.fromMap(maps[i]));
  }

  // ===== DEPARTAMENTOS ===== //

  // Insertar departamento
  Future<void> insertDepartamento(Departamentos departamento) async {
    final db = await database;
    await db.insert(
      'Departamentos',
      departamento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los departamentos
  Future<List<Departamentos>> getAllDepartamentos() async {
    final db = await database;
    final maps = await db.query('Departamentos');
    return List.generate(maps.length, (i) => Departamentos.fromMap(maps[i]));
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

  // ===== COSTOS ===== //

  // Insertar costos
  Future<void> insertCostos(Costos costos) async {
    final db = await database;
    await db.insert(
      'costos',
      costos.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los costos
  Future<List<Costos>> getAllCostos() async {
    final db = await database;
    final maps = await db.query('costos');
    return List.generate(maps.length, (i) => Costos.fromMap(maps[i]));
  }
}

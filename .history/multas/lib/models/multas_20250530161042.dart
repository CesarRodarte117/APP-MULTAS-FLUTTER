import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// SELECT id, clave, nombre FROM agentes;
class Agente {
  int? id;
  String? clave;
  String? nombre;

  Agente({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Agente.fromMap(Map<String, dynamic> map) {
    return Agente(id: map['id'], clave: map['clave'], nombre: map['nombre']);
  }

  @override
  String toString() {
    return 'Agente{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, fechahora, descripcion, status, datos, token FROM bitacora;
class Bitacora {
  int? id;
  String? fechahora;
  String? descripcion;
  String? status;
  String? datos;
  String? token;

  Bitacora({
    this.id,
    this.fechahora,
    this.descripcion,
    this.status,
    this.datos,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechahora': fechahora,
      'descripcion': descripcion,
      'status': status,
      'datos': datos,
      'token': token,
    };
  }

  factory Bitacora.fromMap(Map<String, dynamic> map) {
    return Bitacora(
      id: map['id'],
      fechahora: map['fechahora'],
      descripcion: map['descripcion'],
      status: map['status'],
      datos: map['datos'],
      token: map['token'],
    );
  }

  @override
  String toString() {
    return 'Bitacora{id: $id, fechahora: $fechahora, descripcion: $descripcion, status: $status, datos: $datos, token: $token}';
  }
}

// SELECT id, clave, nombre FROM calles;
class Calle {
  int? id;
  String? clave;
  String? nombre;

  Calle({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Calle.fromMap(Map<String, dynamic> map) {
    return Calle(id: map['id'], clave: map['clave'], nombre: map['nombre']);
  }

  @override
  String toString() {
    return 'Calle{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, clave, fecha, dias FROM catalogos;
class Catalogo {
  int? id;
  String? clave;
  String? fecha;
  String? dias; // Cambiado de int? a String?

  Catalogo({this.id, this.clave, this.fecha, this.dias});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'fecha': fecha, 'dias': dias};
  }

  factory Catalogo.fromMap(Map<String, dynamic> map) {
    return Catalogo(
      id: map['id'],
      clave: map['clave'],
      fecha: map['fecha'],
      dias: map['dias']
          ?.toString(), // Asegura que sea String incluso si viene como número
    );
  }

  @override
  String toString() {
    return 'Catalogo{id: $id, clave: $clave, fecha: $fecha, dias: $dias}';
  }
}

// SELECT id, estado, clave, nombre FROM ciudades;
class Ciudad {
  int? id;
  String? estado;
  String? clave;
  String? nombre;

  Ciudad({this.id, this.estado, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'estado': estado, 'clave': clave, 'nombre': nombre};
  }

  factory Ciudad.fromMap(Map<String, dynamic> map) {
    return Ciudad(
      id: map['id'],
      estado: map['estado'],
      clave: map['clave'],
      nombre: map['nombre'],
    );
  }

  @override
  String toString() {
    return 'Ciudad{id: $id, estado: $estado, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, clave, nombre FROM colonias;
class Colonia {
  int? id;
  String? clave;
  String? nombre;

  Colonia({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Colonia.fromMap(Map<String, dynamic> map) {
    return Colonia(id: map['id'], clave: map['clave'], nombre: map['nombre']);
  }

  @override
  String toString() {
    return 'Colonia{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, clave, valor, descripcion FROM configuracion;
class Configuracion {
  int? id;
  String? clave;
  String? valor;
  String? descripcion;

  Configuracion({this.id, this.clave, this.valor, this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clave': clave,
      'valor': valor,
      'descripcion': descripcion,
    };
  }

  factory Configuracion.fromMap(Map<String, dynamic> map) {
    return Configuracion(
      id: map['id'],
      clave: map['clave'],
      valor: map['valor'],
      descripcion: map['descripcion'],
    );
  }

  @override
  String toString() {
    return 'Configuracion{id: $id, clave: $clave, valor: $valor, descripcion: $descripcion}';
  }
}

// SELECT id, periodo, servicio_medico, salario_minimo, hospedaje, hospedaje_doble, grua_sencilla, grua_operadora, grua_doble FROM costos;
class Costo {
  int? id;
  String? periodo;
  String? servicioMedico;
  String? salarioMinimo;
  String? hospedaje;
  String? hospedajeDoble;
  String? gruaSencilla;
  String? gruaOperadora;
  String? gruaDoble;

  Costo({
    this.id,
    this.periodo,
    this.servicioMedico,
    this.salarioMinimo,
    this.hospedaje,
    this.hospedajeDoble,
    this.gruaSencilla,
    this.gruaOperadora,
    this.gruaDoble,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'periodo': periodo,
      'servicio_medico': servicioMedico,
      'salario_minimo': salarioMinimo,
      'hospedaje': hospedaje,
      'hospedaje_doble': hospedajeDoble,
      'grua_sencilla': gruaSencilla,
      'grua_operadora': gruaOperadora,
      'grua_doble': gruaDoble,
    };
  }

  factory Costo.fromMap(Map<String, dynamic> map) {
    return Costo(
      id: map['id'],
      periodo: map['periodo']?.toString(),
      servicioMedico: map['servicio_medico']?.toString(),
      salarioMinimo: map['salario_minimo']?.toString(),
      hospedaje: map['hospedaje']?.toString(),
      hospedajeDoble: map['hospedaje_doble']?.toString(),
      gruaSencilla: map['grua_sencilla']?.toString(),
      gruaOperadora: map['grua_operadora']?.toString(),
      gruaDoble: map['grua_doble']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Costo{id: $id, periodo: $periodo, servicioMedico: $servicioMedico, salarioMinimo: $salarioMinimo, hospedaje: $hospedaje, hospedajeDoble: $hospedajeDoble, gruaSencilla: $gruaSencilla, gruaOperadora: $gruaOperadora, gruaDoble: $gruaDoble}';
  }
}

// SELECT id, clave, nombre FROM departamentos;
class Departamento {
  int? id;
  String? clave;
  String? nombre;

  Departamento({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Departamento.fromMap(Map<String, dynamic> map) {
    return Departamento(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Departamento{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, clave, nombre FROM documentos;
class Documento {
  int? id;
  String? clave;
  String? nombre;

  Documento({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Documento{id: $id, clave: $clave, nombre: $nombre}';
  }
}

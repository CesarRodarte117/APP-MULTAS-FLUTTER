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

// SELECT id, clave, nombre FROM estaciones;
class Estacion {
  int? id;
  String? clave;
  String? nombre;

  Estacion({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Estacion.fromMap(Map<String, dynamic> map) {
    return Estacion(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Estacion{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, clave, nombre FROM estados;
class Estado {
  int? id;
  String? clave;
  String? nombre;

  Estado({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Estado.fromMap(Map<String, dynamic> map) {
    return Estado(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Estado{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, idsesion, inicial, "final", actual FROM folios;
class Folio {
  int? id;
  String? idSesion;
  String? inicial;
  String? final_;
  String? actual;

  Folio({this.id, this.idSesion, this.inicial, this.final_, this.actual});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idsesion': idSesion,
      'inicial': inicial,
      'final': final_,
      'actual': actual,
    };
  }

  factory Folio.fromMap(Map<String, dynamic> map) {
    return Folio(
      id: map['id'],
      idSesion: map['idsesion']?.toString(),
      inicial: map['inicial']?.toString(),
      final_: map['final']?.toString(),
      actual: map['actual']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Folio{id: $id, idSesion: $idSesion, inicial: $inicial, final: $final_, actual: $actual}';
  }
}

// SELECT id, infraccion, agente, fecha, placas, estado, municipio, calle_infraccion, calle_infraccion2, unidad, departamento, estacion,
// sector, licencia, lic_origen, documento, gps, observaciones, expediente, examen, status, ausente, idsesion, paso1, paso2, paso3, paso4, fechafin, statussaot, foliocaja FROM infraccion;
class Infraccion {
  int? id;
  String? infraccion;
  String? agente;
  String? fecha;
  String? placas;
  String? estado;
  String? municipio;
  String? calleInfraccion;
  String? calleInfraccion2;
  String? unidad;
  String? departamento;
  String? estacion;
  String? sector;
  String? licencia;
  String? licOrigen;
  String? documento;
  String? gps;
  String? observaciones;
  String? expediente;
  String? examen;
  String? status;
  String? ausente;
  String? idSesion;
  String? paso1;
  String? paso2;
  String? paso3;
  String? paso4;
  String? fechaFin;
  String? statusSaot;
  String? folioCaja;

  Infraccion({
    this.id,
    this.infraccion,
    this.agente,
    this.fecha,
    this.placas,
    this.estado,
    this.municipio,
    this.calleInfraccion,
    this.calleInfraccion2,
    this.unidad,
    this.departamento,
    this.estacion,
    this.sector,
    this.licencia,
    this.licOrigen,
    this.documento,
    this.gps,
    this.observaciones,
    this.expediente,
    this.examen,
    this.status,
    this.ausente,
    this.idSesion,
    this.paso1,
    this.paso2,
    this.paso3,
    this.paso4,
    this.fechaFin,
    this.statusSaot,
    this.folioCaja,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'infraccion': infraccion,
      'agente': agente,
      'fecha': fecha,
      'placas': placas,
      'estado': estado,
      'municipio': municipio,
      'calle_infraccion': calleInfraccion,
      'calle_infraccion2': calleInfraccion2,
      'unidad': unidad,
      'departamento': departamento,
      'estacion': estacion,
      'sector': sector,
      'licencia': licencia,
      'lic_origen': licOrigen,
      'documento': documento,
      'gps': gps,
      'observaciones': observaciones,
      'expediente': expediente,
      'examen': examen,
      'status': status,
      'ausente': ausente,
      'idsesion': idSesion,
      'paso1': paso1,
      'paso2': paso2,
      'paso3': paso3,
      'paso4': paso4,
      'fechafin': fechaFin,
      'statussaot': statusSaot,
      'foliocaja': folioCaja,
    };
  }

  factory Infraccion.fromMap(Map<String, dynamic> map) {
    return Infraccion(
      id: map['id'],
      infraccion: map['infraccion']?.toString(),
      agente: map['agente']?.toString(),
      fecha: map['fecha']?.toString(),
      placas: map['placas']?.toString(),
      estado: map['estado']?.toString(),
      municipio: map['municipio']?.toString(),
      calleInfraccion: map['calle_infraccion']?.toString(),
      calleInfraccion2: map['calle_infraccion2']?.toString(),
      unidad: map['unidad']?.toString(),
      departamento: map['departamento']?.toString(),
      estacion: map['estacion']?.toString(),
      sector: map['sector']?.toString(),
      licencia: map['licencia']?.toString(),
      licOrigen: map['lic_origen']?.toString(),
      documento: map['documento']?.toString(),
      gps: map['gps']?.toString(),
      observaciones: map['observaciones']?.toString(),
      expediente: map['expediente']?.toString(),
      examen: map['examen']?.toString(),
      status: map['status']?.toString(),
      ausente: map['ausente']?.toString(),
      idSesion: map['idsesion']?.toString(),
      paso1: map['paso1']?.toString(),
      paso2: map['paso2']?.toString(),
      paso3: map['paso3']?.toString(),
      paso4: map['paso4']?.toString(),
      fechaFin: map['fechafin']?.toString(),
      statusSaot: map['statussaot']?.toString(),
      folioCaja: map['foliocaja']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Infraccion{id: $id, infraccion: $infraccion, agente: $agente, fecha: $fecha, placas: $placas, estado: $estado, municipio: $municipio, calleInfraccion: $calleInfraccion, calleInfraccion2: $calleInfraccion2, unidad: $unidad, departamento: $departamento, estacion: $estacion, sector: $sector, licencia: $licencia, licOrigen: $licOrigen, documento: $documento, gps: $gps, observaciones: $observaciones, expediente: $expediente, examen: $examen, status: $status, ausente: $ausente, idSesion: $idSesion, paso1: $paso1, paso2: $paso2, paso3: $paso3, paso4: $paso4, fechaFin: $fechaFin, statusSaot: $statusSaot, folioCaja: $folioCaja}';
  }
}

// SELECT id, idinfraccion, infraccion, importe, idinfraccionrel FROM infraccionadeudos;
class InfraccionAdeudo {
  int? id;
  int? idInfraccion;
  String? infraccion;
  String? importe;
  int? idInfraccionRel;

  InfraccionAdeudo({
    this.id,
    this.idInfraccion,
    this.infraccion,
    this.importe,
    this.idInfraccionRel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idinfraccion': idInfraccion,
      'infraccion': infraccion,
      'importe': importe,
      'idinfraccionrel': idInfraccionRel,
    };
  }

  factory InfraccionAdeudo.fromMap(Map<String, dynamic> map) {
    return InfraccionAdeudo(
      id: map['id'],
      idInfraccion: map['idinfraccion'],
      infraccion: map['infraccion']?.toString(),
      importe: map['importe']?.toString(),
      idInfraccionRel: map['idinfraccionrel'],
    );
  }

  @override
  String toString() {
    return 'InfraccionAdeudo{id: $id, idInfraccion: $idInfraccion, infraccion: $infraccion, importe: $importe, idInfraccionRel: $idInfraccionRel}';
  }
}

// SELECT id, idinfraccion, nombre, apaterno, amaterno, edad, genero, domicilio, numext, numint, colonia, codigo_postal, telefono FROM infraccionconductor;
class InfraccionConductor {
  int? id;
  String? idInfraccion;
  String? nombre;
  String? aPaterno;
  String? aMaterno;
  String? edad;
  String? genero;
  String? domicilio;
  String? numExt;
  String? numInt;
  String? colonia;
  String? codigoPostal;
  String? telefono;

  InfraccionConductor({
    this.id,
    this.idInfraccion,
    this.nombre,
    this.aPaterno,
    this.aMaterno,
    this.edad,
    this.genero,
    this.domicilio,
    this.numExt,
    this.numInt,
    this.colonia,
    this.codigoPostal,
    this.telefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idinfraccion': idInfraccion,
      'nombre': nombre,
      'apaterno': aPaterno,
      'amaterno': aMaterno,
      'edad': edad,
      'genero': genero,
      'domicilio': domicilio,
      'numext': numExt,
      'numint': numInt,
      'colonia': colonia,
      'codigo_postal': codigoPostal,
      'telefono': telefono,
    };
  }

  factory InfraccionConductor.fromMap(Map<String, dynamic> map) {
    return InfraccionConductor(
      id: map['id'],
      idInfraccion: map['idinfraccion']?.toString(),
      nombre: map['nombre']?.toString(),
      aPaterno: map['apaterno']?.toString(),
      aMaterno: map['amaterno']?.toString(),
      edad: map['edad']?.toString(),
      genero: map['genero']?.toString(),
      domicilio: map['domicilio']?.toString(),
      numExt: map['numext']?.toString(),
      numInt: map['numint']?.toString(),
      colonia: map['colonia']?.toString(),
      codigoPostal: map['codigo_postal']?.toString(),
      telefono: map['telefono']?.toString(),
    );
  }

  @override
  String toString() {
    return 'InfraccionConductor{id: $id, idInfraccion: $idInfraccion, nombre: $nombre, aPaterno: $aPaterno, aMaterno: $aMaterno, edad: $edad, genero: $genero, domicilio: $domicilio, numExt: $numExt, numInt: $numInt, colonia: $colonia, codigoPostal: $codigoPostal, telefono: $telefono}';
  }
}

// SELECT id, idinfraccion, clave, importe FROM infraccionimportes;
class InfraccionImporte {
  int? id;
  String? idInfraccion;
  String? clave;
  String? importe;

  InfraccionImporte({this.id, this.idInfraccion, this.clave, this.importe});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idinfraccion': idInfraccion,
      'clave': clave,
      'importe': importe,
    };
  }

  factory InfraccionImporte.fromMap(Map<String, dynamic> map) {
    return InfraccionImporte(
      id: map['id'],
      idInfraccion: map['idinfraccion']?.toString(),
      clave: map['clave']?.toString(),
      importe: map['importe']?.toString(),
    );
  }

  @override
  String toString() {
    return 'InfraccionImporte{id: $id, idInfraccion: $idInfraccion, clave: $clave, importe: $importe}';
  }
}

// SELECT id, idinfraccion, motivo, uma, importe, descuento, periodo_descuento FROM infraccionmotivos;
class InfraccionMotivo {
  int? id;
  String? idInfraccion;
  String? motivo;
  String? uma;
  String? importe;
  String? descuento;
  String? periodoDescuento;

  InfraccionMotivo({
    this.id,
    this.idInfraccion,
    this.motivo,
    this.uma,
    this.importe,
    this.descuento,
    this.periodoDescuento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idinfraccion': idInfraccion,
      'motivo': motivo,
      'uma': uma,
      'importe': importe,
      'descuento': descuento,
      'periodo_descuento': periodoDescuento,
    };
  }

  factory InfraccionMotivo.fromMap(Map<String, dynamic> map) {
    return InfraccionMotivo(
      id: map['id'],
      idInfraccion: map['idinfraccion']?.toString(),
      motivo: map['motivo']?.toString(),
      uma: map['uma']?.toString(),
      importe: map['importe']?.toString(),
      descuento: map['descuento']?.toString(),
      periodoDescuento: map['periodo_descuento']?.toString(),
    );
  }

  @override
  String toString() {
    return 'InfraccionMotivo{id: $id, idInfraccion: $idInfraccion, motivo: $motivo, uma: $uma, importe: $importe, descuento: $descuento, periodoDescuento: $periodoDescuento}';
  }
}

// SELECT id, idpago, idinfraccion, importe, infraccion FROM infraccionpagos;
class InfraccionPago {
  int? id;
  String? idPago;
  String? idInfraccion;
  String? importe;
  String? infraccion;

  InfraccionPago({
    this.id,
    this.idPago,
    this.idInfraccion,
    this.importe,
    this.infraccion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idpago': idPago,
      'idinfraccion': idInfraccion,
      'importe': importe,
      'infraccion': infraccion,
    };
  }

  factory InfraccionPago.fromMap(Map<String, dynamic> map) {
    return InfraccionPago(
      id: map['id'],
      idPago: map['idpago']?.toString(),
      idInfraccion: map['idinfraccion']?.toString(),
      importe: map['importe']?.toString(),
      infraccion: map['infraccion']?.toString(),
    );
  }

  @override
  String toString() {
    return 'InfraccionPago{id: $id, idPago: $idPago, idInfraccion: $idInfraccion, importe: $importe, infraccion: $infraccion}';
  }
}

// SELECT id, idinfraccion, gruaschicas, gruasgrandes, lote, inventario FROM infraccionretencion;
class Infraccionretencion {
  int? id;
  String? idinfraccion;
  String? gruaschicas;
  String? gruasgrandes;
  String? lote;
  String? inventario;

  Infraccionretencion({
    this.id,
    this.idinfraccion,
    this.gruaschicas,
    this.gruasgrandes,
    this.lote,
    this.inventario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idinfraccion': idinfraccion,
      'gruaschicas': gruaschicas,
      'gruasgrandes': gruasgrandes,
      'lote': lote,
      'inventario': inventario,
    };
  }

  factory Infraccionretencion.fromMap(Map<String, dynamic> map) {
    return Infraccionretencion(
      id: map['id'],
      idinfraccion: map['idinfraccion']?.toString(),
      gruaschicas: map['gruaschicas']?.toString(),
      gruasgrandes: map['gruasgrandes']?.toString(),
      lote: map['lote']?.toString(),
      inventario: map['inventario']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Infraccionretencion{id: $id, idinfraccion: $idinfraccion, gruaschicas: $gruaschicas, gruasgrandes: $gruasgrandes, lote: $lote, inventario: $inventario}';
  }
}

// SELECT id, idinfraccion, marca, submarca, modelo, color, extranjero FROM infraccionvehiculo;
class Infraccionvehiculo {
  int? id;
  String? idinfraccion;
  String? marca;
  String? submarca;
  String? modelo;
  String? color;
  String? extranjero;

  Infraccionvehiculo({
    this.id,
    this.idinfraccion,
    this.marca,
    this.submarca,
    this.modelo,
    this.color,
    this.extranjero,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idinfraccion': idinfraccion,
      'marca': marca,
      'submarca': submarca,
      'modelo': modelo,
      'color': color,
      'extranjero': extranjero,
    };
  }

  factory Infraccionvehiculo.fromMap(Map<String, dynamic> map) {
    return Infraccionvehiculo(
      id: map['id'],
      idinfraccion: map['idinfraccion']?.toString(),
      marca: map['marca']?.toString(),
      submarca: map['submarca']?.toString(),
      modelo: map['modelo']?.toString(),
      color: map['color']?.toString(),
      extranjero: map['extranjero']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Infraccionvehiculo{id: $id, idinfraccion: $idinfraccion, marca: $marca, submarca: $submarca, modelo: $modelo, color: $color, extranjero: $extranjero}';
  }
}

// SELECT id, clave, nombre FROM lotes;
class Lotes {
  int? id;
  String? clave;
  String? nombre;

  Lotes({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Lotes.fromMap(Map<String, dynamic> map) {
    return Lotes(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Lotes{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, clave, nombre FROM marcas;
class Marcas {
  int? id;
  String? clave;
  String? nombre;

  Marcas({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Marcas.fromMap(Map<String, dynamic> map) {
    return Marcas(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Marcas{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, clave, nombre, uma, descuento, periodo_descuento, peritos, articulo, fraccion, sancion FROM motivos;
class Motivos {
  int? id;
  String? clave;
  String? nombre;
  String? uma;
  String? descuento;
  String? periodo_descuento;
  String? peritos;
  String? articulo;
  String? fraccion;
  String? sancion;

  Motivos({
    this.id,
    this.clave,
    this.nombre,
    this.uma,
    this.descuento,
    this.periodo_descuento,
    this.peritos,
    this.articulo,
    this.fraccion,
    this.sancion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clave': clave,
      'nombre': nombre,
      'uma': uma,
      'descuento': descuento,
      'periodo_descuento': periodo_descuento,
      'peritos': peritos,
      'articulo': articulo,
      'fraccion': fraccion,
      'sancion': sancion,
    };
  }

  factory Motivos.fromMap(Map<String, dynamic> map) {
    return Motivos(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
      uma: map['uma']?.toString(),
      descuento: map['descuento']?.toString(),
      periodo_descuento: map['periodo_descuento']?.toString(),
      peritos: map['peritos']?.toString(),
      articulo: map['articulo']?.toString(),
      fraccion: map['fraccion']?.toString(),
      sancion: map['sancion']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Motivos{id: $id, clave: $clave, nombre: $nombre, uma: $uma, descuento: $descuento, periodo_descuento: $periodo_descuento, peritos: $peritos, articulo: $articulo, fraccion: $fraccion, sancion: $sancion}';
  }
}

// SELECT id, respuesta, autorizacion, cfolio, orderid, fecha_hora, total, status FROM pagos;
class Pagos {
  int? id;
  String? respuesta;
  String? autorizacion;
  String? cfolio;
  String? orderid;
  String? fecha_hora;
  String? total;
  String? status;

  Pagos({
    this.id,
    this.respuesta,
    this.autorizacion,
    this.cfolio,
    this.orderid,
    this.fecha_hora,
    this.total,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'respuesta': respuesta,
      'autorizacion': autorizacion,
      'cfolio': cfolio,
      'orderid': orderid,
      'fecha_hora': fecha_hora,
      'total': total,
      'status': status,
    };
  }

  factory Pagos.fromMap(Map<String, dynamic> map) {
    return Pagos(
      id: map['id'],
      respuesta: map['respuesta']?.toString(),
      autorizacion: map['autorizacion']?.toString(),
      cfolio: map['cfolio']?.toString(),
      orderid: map['orderid']?.toString(),
      fecha_hora: map['fecha_hora']?.toString(),
      total: map['total']?.toString(),
      status: map['status']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Pagos{id: $id, respuesta: $respuesta, autorizacion: $autorizacion, cfolio: $cfolio, orderid: $orderid, fecha_hora: $fecha_hora, total: $total, status: $status}';
  }
}

// SELECT id, clave, valor, descripcion FROM parametros;
class Parametros {
  int? id;
  String? clave;
  String? valor;
  String? descripcion;

  Parametros({this.id, this.clave, this.valor, this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clave': clave,
      'valor': valor,
      'descripcion': descripcion,
    };
  }

  factory Parametros.fromMap(Map<String, dynamic> map) {
    return Parametros(
      id: map['id'],
      clave: map['clave']?.toString(),
      valor: map['valor']?.toString(),
      descripcion: map['descripcion']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Parametros{id: $id, clave: $clave, valor: $valor, descripcion: $descripcion}';
  }
}

// SELECT id, clave, nombre FROM sectores;
class Sectores {
  int? id;
  String? clave;
  String? nombre;

  Sectores({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Sectores.fromMap(Map<String, dynamic> map) {
    return Sectores(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Sectores{id: $id, clave: $clave, nombre: $nombre}';
  }
}

// SELECT id, status, fechahora, clave, nombre, contrasena, token, mensaje FROM sesion;
class Sesion {
  int? id;
  String? status;
  String? fechahora;
  String? clave;
  String? nombre;
  String? contrasena;
  String? token;
  String? mensaje;

  Sesion({
    this.id,
    this.status,
    this.fechahora,
    this.clave,
    this.nombre,
    this.contrasena,
    this.token,
    this.mensaje,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'fechahora': fechahora,
      'clave': clave,
      'nombre': nombre,
      'contrasena': contrasena,
      'token': token,
      'mensaje': mensaje,
    };
  }

  factory Sesion.fromMap(Map<String, dynamic> map) {
    return Sesion(
      id: map['id'],
      status: map['status']?.toString(),
      fechahora: map['fechahora']?.toString(),
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
      contrasena: map['contrasena']?.toString(),
      token: map['token']?.toString(),
      mensaje: map['mensaje']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Sesion{id: $id, status: $status, fechahora: $fechahora, clave: $clave, nombre: $nombre, contrasena: $contrasena, token: $token, mensaje: $mensaje}';
  }
}

// SELECT id, clave, nombre, marca FROM submarcas;
class Submarcas {
  int? id;
  String? clave;
  String? nombre;
  String? marca;

  Submarcas({this.id, this.clave, this.nombre, this.marca});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre, 'marca': marca};
  }

  factory Submarcas.fromMap(Map<String, dynamic> map) {
    return Submarcas(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
      marca: map['marca']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Submarcas{id: $id, clave: $clave, nombre: $nombre, marca: $marca}';
  }
}

// SELECT id, clave, nombre FROM unidades;
class Unidades {
  int? id;
  String? clave;
  String? nombre;

  Unidades({this.id, this.clave, this.nombre});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clave': clave, 'nombre': nombre};
  }

  factory Unidades.fromMap(Map<String, dynamic> map) {
    return Unidades(
      id: map['id'],
      clave: map['clave']?.toString(),
      nombre: map['nombre']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Unidades{id: $id, clave: $clave, nombre: $nombre}';
  }
}

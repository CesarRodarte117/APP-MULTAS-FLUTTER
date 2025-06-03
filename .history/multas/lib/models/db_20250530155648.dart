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
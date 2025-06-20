import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

// ANDROID S/N --Android 9 (Pie)	API 28	2018
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

//GUARDAR INFO
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Añade estos imports adicionales al inicio del archivo
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Clave global para mostrar diálogos sin pasar BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<String?> getOrCreatePersistentDirectory() async {
  Directory baseDir;

  if (Platform.isAndroid) {
    baseDir = Directory('/storage/emulated/0/Documents/MultasData');
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt >= 30) {
      final status = await Permission.manageExternalStorage.request();

      if (status.isDenied || status.isPermanentlyDenied) {
        _mostrarDialogoPermisoDenegado();
        return null;
      }
    } else {
      final status = await Permission.storage.request();

      if (status.isDenied || status.isPermanentlyDenied) {
        _mostrarDialogoPermisoDenegado();
        return null;
      }
    }
  } else {
    baseDir = await getApplicationDocumentsDirectory();
  }

  if (!await baseDir.exists()) {
    await baseDir.create(recursive: true);
    debugPrint('✅ Directorio creado en: ${baseDir.path}');
  }

  return baseDir.path;
}

void _mostrarDialogoPermisoDenegado() {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Permiso requerido'),
      content: Text(
        'Necesitamos acceso al almacenamiento para guardar información.\n\n'
        'Por favor ve a configuración y habilítalo manualmente.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            openAppSettings();
          },
          child: Text('Abrir configuración'),
        ),
      ],
    ),
  );
}

//leer los datos de un archivo persistente
Future<void> printAllFilesContent() async {
  try {
    final dirPath = await getOrCreatePersistentDirectory();
    if (dirPath == null) {
      throw Exception('Error: No se pudo obtener el directorio persistente.');
    }
    final directory = Directory(dirPath);
    final files = await directory.list().toList();

    for (var file in files) {
      if (file is File) {
        try {
          final content = await file.readAsString();
          print('\n📄 Archivo: ${file.path}');
          print('-------------------------------------');
          print(content);
          print('-------------------------------------');
        } catch (e) {
          print('❌ Error al leer ${file.path}: $e');
        }
      }
    }
  } catch (e) {
    print('❌ Error al listar archivos: $e');
  }
}

// Añade esta función para obtener el package name
Future<String> _getPackageName() async {
  try {
    const channel = MethodChannel('flutter.native/helper');
    return await channel.invokeMethod('getPackageName');
  } catch (e) {
    debugPrint('Error al obtener package name: $e');
    return 'com.default.package';
  }
}

Future<String?> readPersistentFile(String filename) async {
  try {
    final dirPath = await getOrCreatePersistentDirectory();
    final file = File('$dirPath/$filename');
    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  } catch (e) {
    print('❌ Error al leer archivo: $e');
    return null;
  }
}

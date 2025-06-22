import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

// Clave global para mostrar diálogos sin pasar BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class StoragePermissionsHandler {
  static final StoragePermissionsHandler _instance =
      StoragePermissionsHandler._internal();
  factory StoragePermissionsHandler() => _instance;
  StoragePermissionsHandler._internal();

  Future<bool> verifyStoragePermissions(BuildContext context) async {
    bool permissionsGranted = false;

    while (!permissionsGranted) {
      final status = await _getStoragePermissionStatus();

      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          final shouldOpenSettings = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Permisos de Almacenamiento Requeridos'),
              content: const Text(
                'La aplicación necesita acceso al almacenamiento para guardar datos. '
                'Por favor habilita los permisos en configuración.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Abrir Configuración'),
                ),
              ],
            ),
          );

          if (shouldOpenSettings == true) {
            await openAppSettings();
          } else {
            return false;
          }
        } else {
          final result = await _requestStoragePermission();
          if (result.isGranted) {
            permissionsGranted = true;
          }
        }
      } else {
        permissionsGranted = true;
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    return true;
  }

  Future<bool> hasStoragePermissions() async {
    final status = await _getStoragePermissionStatus();
    return status.isGranted;
  }

  Future<PermissionStatus> _getStoragePermissionStatus() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        return await Permission.manageExternalStorage.status;
      } else {
        return await Permission.storage.status;
      }
    } else {
      return PermissionStatus.granted;
    }
  }

  Future<PermissionStatus> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        return await Permission.manageExternalStorage.request();
      } else {
        return await Permission.storage.request();
      }
    } else {
      return PermissionStatus.granted;
    }
  }
}

Future<String?> getOrCreatePersistentDirectory(BuildContext context) async {
  Directory baseDir;

  // Verificar permisos primero
  final hasPermissions = await StoragePermissionsHandler()
      .verifyStoragePermissions(context);
  if (!hasPermissions) {
    return null;
  }

  if (Platform.isAndroid) {
    baseDir = Directory('/storage/emulated/0/Documents/MultasData');
  } else {
    baseDir = await getApplicationDocumentsDirectory();
  }

  if (!await baseDir.exists()) {
    await baseDir.create(recursive: true);
    debugPrint('✅ Directorio creado en: ${baseDir.path}');
  }

  return baseDir.path;
}

// Función alternativa sin contexto (usa la navigatorKey)
Future<String?> getOrCreatePersistentDirectoryWithoutContext() async {
  final context = navigatorKey.currentContext;
  if (context == null) return null;

  return await getOrCreatePersistentDirectory(context);
}

Future<void> printAllFilesContent(BuildContext context) async {
  try {
    final dirPath = await getOrCreatePersistentDirectory(context);
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

Future<String> _getPackageName() async {
  try {
    const channel = MethodChannel('flutter.native/helper');
    return await channel.invokeMethod('getPackageName');
  } catch (e) {
    debugPrint('Error al obtener package name: $e');
    return 'com.default.package';
  }
}

Future<String?> readPersistentFile(
  String filename, {
  BuildContext? context,
}) async {
  try {
    final dirPath = context != null
        ? await getOrCreatePersistentDirectory(context)
        : await getOrCreatePersistentDirectoryWithoutContext();

    if (dirPath == null) return null;

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

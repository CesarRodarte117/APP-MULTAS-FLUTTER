import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

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

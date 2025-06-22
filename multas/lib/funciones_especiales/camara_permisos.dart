import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermisosHandler {
  // Instancia singleton
  static final PermisosHandler _instance = PermisosHandler._internal();
  factory PermisosHandler() => _instance;
  PermisosHandler._internal();

  // Verificar permisos de cámara persistentemente
  Future<bool> verificarPermisosCamara(BuildContext context) async {
    bool permisosOtorgados = false;

    while (!permisosOtorgados) {
      final status = await Permission.camera.status;

      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          // Mostrar diálogo para ir a configuración
          final shouldOpenSettings = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Permisos Requeridos'),
              content: const Text(
                'La aplicación necesita acceso a la cámara para funcionar correctamente. '
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
          // Solicitar permisos normalmente
          final result = await Permission.camera.request();
          if (result.isGranted) {
            permisosOtorgados = true;
          }
        }
      } else {
        permisosOtorgados = true;
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    return true;
  }

  // Verificar rápidamente si ya tiene permisos (sin UI)
  Future<bool> tienePermisosCamara() async {
    return await Permission.camera.isGranted;
  }
}

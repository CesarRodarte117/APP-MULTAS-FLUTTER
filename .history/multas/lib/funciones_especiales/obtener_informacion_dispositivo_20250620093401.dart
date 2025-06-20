// ANDROID S/N --Android 9 (Pie)	API 28	2018
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

//GUARDAR INFO
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> obtenerAndroidSN() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.serialNumber ?? 'No disponible';
}

Future<String> obtenerAndroidID() async {
  String? androidId;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  androidId =
      'ID:' +
      androidInfo.id +
      '--MODELO:' +
      androidInfo.model +
      '--FABRICANTE:' +
      androidInfo.brand +
      '--ANDROID:' +
      androidInfo.version.release +
      '--NOMBRE:' +
      androidInfo.name;
  ;

  return androidId ?? 'No disponible';
}

import 'package:flutter/material.dart';

// VIEWS
import 'package:multas/views/menu_principal.dart';

// CONTROLLERS

// ANDROID S/N --Android 9 (Pie)	API 28	2018
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

//GUARDAR INFO
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> _checkAndRequestStoragePermissions() async {
  if (!Platform.isAndroid) return true;

  // Para Android 13 (API 33)
  if (await DeviceInfoPlugin().androidInfo.then(
        (info) => info.version.sdkInt,
      ) >=
      33) {
    if (!await Permission.manageExternalStorage.isGranted) {
      return await Permission.manageExternalStorage.request().isGranted;
    }
    return true;
  }

  // Para Android 10-12 (API 29-32)
  if (await DeviceInfoPlugin().androidInfo.then(
        (info) => info.version.sdkInt,
      ) >=
      29) {
    if (!await Permission.storage.isGranted) {
      return await Permission.storage.request().isGranted;
    }
    return true;
  }

  // Para Android 6-9 (API 23-28)
  if (!await Permission.storage.isGranted) {
    return await Permission.storage.request().isGranted;
  }
  return true;
}

Future<String> getStoragePath() async {
  if (Platform.isAndroid) {
    // Para Android 10+ usa el directorio específico de la app
    final sdkVersion = await DeviceInfoPlugin().androidInfo.then(
      (info) => info.version.sdkInt,
    );
    if (sdkVersion >= 29) {
      return (await getApplicationDocumentsDirectory()).path;
    }
    // Para versiones anteriores usa almacenamiento externo
    return (await getExternalStorageDirectory())?.path ??
        '/storage/emulated/0/Android/data/${await _getPackageName()}/files';
  }
  return (await getApplicationDocumentsDirectory()).path;
}

Future<String> _getPackageName() async {
  const channel = MethodChannel('flutter.native/helper');
  return await channel.invokeMethod('getPackageName');
}

Future<String> getOrCreatePersistentDirectory() async {
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Permisos de almacenamiento denegados');
    }
  }

  Directory? baseDir;

  try {
    if (Platform.isAndroid) {
      baseDir = await getExternalStorageDirectory();
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }

    if (baseDir == null) {
      throw Exception('No se pudo obtener el directorio externo');
    }

    final appDir = Directory('${baseDir.path}/MyAppPersistentData');

    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
      print('✅ Directorio creado: ${appDir.path}');
    } else {
      print('ℹ️ Directorio ya existe: ${appDir.path}');
    }

    return appDir.path;
  } catch (e) {
    print('❌ Error al obtener/crear directorio: $e');
    throw Exception('Error al acceder al almacenamiento');
  }
}

Future<void> savePersistentFile(String filename, String content) async {
  try {
    final dirPath = await getOrCreatePersistentDirectory();
    final file = File('$dirPath/$filename');
    await file.writeAsString(content);
    print('📁 Archivo guardado en: ${file.path}');
  } catch (e) {
    print('❌ Error al guardar archivo: $e');
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  int _selectedIndex = 0;
  bool _obscurePassword = true;
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  // Función para guardar las credenciales
  Future<void> _saveCredentials(String user, String password) async {
    try {
      // Crear un mapa con las credenciales
      final credentials = {
        'user': user,
        'password': password,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Convertir a JSON
      final credentialsJson = credentials.toString();

      // Guardar en archivo
      await savePersistentFile('user_credentials.txt', credentialsJson);
      print('🔐 Credenciales guardadas correctamente');
    } catch (e) {
      print('❌ Error al guardar credenciales: $e');
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final matricula = _matriculaController.text;
      final password = _passwordController.text;

      if (matricula == '666' && password == '666') {
        setState(() {
          _errorMessage = null;
        });

        // Guardar las credenciales
        await _saveCredentials(matricula, password);

        //S/N
        String? serial = await obtenerAndroidSN();

        if (serial == 'unknown' ||
            serial.isEmpty ||
            serial == 'No disponible') {
          serial = await obtenerAndroidID();
        } else {
          serial = 'SN' + serial;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sesión exitosa\nSerie: $serial')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuPrincipal()),
        );
      } else {
        setState(() {
          _errorMessage = 'Matrícula o contraseña incorrecta';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/logoheroica.png'),
                  ),
                  Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: TextFormField(
                          controller: _matriculaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Matrícula',
                            hintText: 'Ingresa tu matrícula',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu matrícula';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 26),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: 'Ingresa tu contraseña',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 26),
                  TextButton(
                    onPressed: _login,
                    child: const Text(
                      "Iniciar Sesión",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 124, 36, 57),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

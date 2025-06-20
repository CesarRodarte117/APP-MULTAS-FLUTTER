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

// Añade estos imports adicionales al inicio del archivo
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

//leer los datos de un archivo persistente
Future<void> printAllFilesContent() async {
  try {
    final dirPath = await getOrCreatePersistentDirectory();
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

// Obtiene el directorio persistente de la aplicación
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
    debugPrint('✅ Directorio creado en ubicación: ${baseDir.path}');
  }

  return baseDir.path;
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

  // Función para guardar datos
  Future<void> _saveCredentials(String user, String password) async {
    try {
      final dirPath = await getOrCreatePersistentDirectory();
      final file = File('$dirPath/multas_credentials.json');

      List<Map<String, dynamic>> allCredentials = [];

      // Leer datos existentes
      if (await file.exists()) {
        final content = await file.readAsString();
        allCredentials = List<Map<String, dynamic>>.from(jsonDecode(content));
      }

      // Añadir nuevo registro para no borrar los anteriores
      allCredentials.add({
        'user': user,
        'password': password, // ⚠️encriptación
        'timestamp': DateTime.now().toIso8601String(),
        'device_id':
            await obtenerAndroidID(), // Identificador único del dispositivo
      });

      // Guardar
      await file.writeAsString(jsonEncode(allCredentials));

      debugPrint('🔐 Datos guardados en ubicación: ${file.path}');
      debugPrint('📊 Total de registros: ${allCredentials.length}');
    } catch (e) {
      debugPrint('❌ Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar datos persistentes: ${e.toString()}'),
        ),
      );
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final matricula = _matriculaController.text;
      final password = _passwordController.text;

      // Guardar las credenciales
      await _saveCredentials(matricula, password);
      await printAllFilesContent();
      if (matricula == '666' && password == '666') {
        setState(() {
          _errorMessage = null;
        });

        // // Guardar las credenciales
        // await _saveCredentials(matricula, password);

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

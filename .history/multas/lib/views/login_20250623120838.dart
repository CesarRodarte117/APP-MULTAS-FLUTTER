import 'package:flutter/material.dart';

// VIEWS
import 'package:multas/views/menu_principal.dart';

// IMPORTS
import 'package:multas/funciones_especiales/almacenamiento_permisos.dart';
import 'package:multas/funciones_especiales/obtener_informacion_dispositivo.dart';
import 'package:multas/funciones_especiales/camara_permisos.dart';

// CONTROLLERS

//GUARDAR INFO
import 'dart:io';

// Añade estos imports adicionales al inicio del archivo
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  // Función para intentar auto-login
  Future<void> _tryAutoLogin() async {
    if (_autoLoginAttempted) return;
    _autoLoginAttempted = true;

    final prefs = await SharedPreferences.getInstance();
    final savedMatricula = prefs.getString('matricula');
    final savedPassword = prefs.getString('password');

    if (savedMatricula != null && savedPassword != null) {
      setState(() {
        _isLoading = true;
      });

      // Simulamos un pequeño delay para que se vea mejor la UI
      await Future.delayed(const Duration(milliseconds: 500));

      // Rellenamos los campos
      _matriculaController.text = savedMatricula;
      _passwordController.text = savedPassword;

      // Intentamos el login automático
      await _login();

      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para guardar datos
  Future<void> _saveCredentials(String user, String password) async {
    try {
      final dirPath = await getOrCreatePersistentDirectory(context);
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

  Future<void> _login() async {
    // Verificar permisos de almacenamiento
    final dirPath = await getOrCreatePersistentDirectory(context);

    // Si no se pudo obtener el directorio, el usuario no iniciara sesión
    if (dirPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los permisos de almacenamiento'),
        ),
      );
      return;
    }

    final camaraTienePermisos = await PermisosHandler().verificarPermisosCamara(
      context,
    );

    if (!camaraTienePermisos) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes aceptar los permisos de cámara')),
        );
      }
      return;
    }

    // Validar el formulario
    if (_formKey.currentState!.validate()) {
      final matricula = _matriculaController.text;
      final password = _passwordController.text;

      // Guardar las credenciales
      await _saveCredentials(matricula, password);
      await printAllFilesContent(context);
      if (matricula == '666' && password == '666') {
        setState(() {
          _errorMessage = null;
        });

        // // Guardar las credenciales
        // await _saveCredentials(matricula, password);

        // Obtener el número de serie del dispositivo Android
        String? serial = await obtenerAndroidSN();

        // Si el número de serie es desconocido o no disponible, usar Android ID
        if (serial == 'unknown' ||
            serial.isEmpty ||
            serial == 'No disponible') {
          serial = await obtenerAndroidID();
        } else {
          serial = 'SN' + serial;
        }

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sesión exitosa\nSerie: $serial')),
        );

        // Navegar a la pantalla principal
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

  // PREGUNTAMOS QUE ACEPTA LOS PERMISOS
  @override
  void initState() {
    super.initState();
    _initDirectory();
  }

  void _initDirectory() async {
    await getOrCreatePersistentDirectory(context);
    await PermisosHandler().verificarPermisosCamara(context);
  }

  //CUERPO PRINCIPAL DEL LOGIN
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

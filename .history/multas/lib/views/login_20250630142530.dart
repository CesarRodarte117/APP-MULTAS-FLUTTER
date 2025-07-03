import 'package:flutter/material.dart';
import 'package:multas/models/db.dart';

// VIEWS
import 'package:multas/views/menu_principal.dart';

// IMPORTS
import 'package:multas/funciones_especiales/almacenamiento_permisos.dart';
import 'package:multas/funciones_especiales/obtener_informacion_dispositivo.dart';
import 'package:multas/funciones_especiales/camara_permisos.dart';

// funciones especiales
import 'package:multas/funciones_especiales/verificar_session.dart';

//catalogos
import 'package:multas/catalogos/descargar_catalogos.dart';

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
  bool _isLoading = false;
  String _loadingMessage = '';

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
    // Validar el formulario
    if (_formKey.currentState!.validate()) {
      final matricula = _matriculaController.text;
      final password = _passwordController.text;

      setState(() {
        _isLoading = true;
        _loadingMessage = 'Verificando credenciales...';
      });

      try {
        if (matricula == '666' && password == '666') {
          setState(() {
            _errorMessage = null;
            _loadingMessage = 'Validando sesión...';
          });

          // Guardar las credenciales
          await _saveCredentials(matricula, password);
          await printAllFilesContent(context);

          AuthService.saveSession(password, matricula);

          // Verificar si necesitamos descargar catálogos
          setState(() {
            _loadingMessage = 'Verificando catálogos...';
          });

          final dbHelper = DatabaseHelper();
          final catalogoService = CatalogoService(dbHelper: dbHelper);

          // // Verificación y descarga de todos los catálogos
          // final countCalles = await dbHelper.countCalles();
          // if (countCalles == 0) {
          //   setState(() {
          //     _loadingMessage = 'Descargando calles...';
          //   });

          //   final success = await catalogoService.descargarCalles();
          //   if (!success) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text('Error al descargar calles')),
          //     );
          //   }
          // }

          // final countColonias = await dbHelper.countColonias();
          // if (countColonias == 0) {
          //   setState(() {
          //     _loadingMessage = 'Descargando colonias...';
          //   });

          //   final success = await catalogoService.descargarColonias();
          //   if (!success) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text('Error al descargar colonias')),
          //     );
          //   }
          // }

          final countMarcas = await dbHelper.countMarcas();
          if (countMarcas == 0) {
            setState(() {
              _loadingMessage = 'Descargando marcas...';
            });

            final success = await catalogoService.descargarMarcas();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar marcas')),
              );
            }
          }

          final countSectores = await dbHelper.countSectores();
          if (countSectores == 0) {
            setState(() {
              _loadingMessage = 'Descargando sectores...';
            });

            final success = await catalogoService.descargarSectores();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar sectores')),
              );
            }
          }

          final countUnidades = await dbHelper.countUnidades();
          if (countUnidades == 0) {
            setState(() {
              _loadingMessage = 'Descargando unidades...';
            });

            final success = await catalogoService.descargarUnidades();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar unidades')),
              );
            }
          }

          final countDocumentos = await dbHelper.countDocumentos();
          if (countDocumentos == 0) {
            setState(() {
              _loadingMessage = 'Descargando documentos...';
            });

            final success = await catalogoService.descargarDocumentos();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar documentos')),
              );
            }
          }

          final countEstaciones = await dbHelper.countEstaciones();
          if (countEstaciones == 0) {
            setState(() {
              _loadingMessage = 'Descargando estaciones...';
            });

            final success = await catalogoService.descargarEstaciones();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar estaciones')),
              );
            }
          }

          final countLotes = await dbHelper.countLotes();
          if (countLotes == 0) {
            setState(() {
              _loadingMessage = 'Descargando lotes...';
            });

            final success = await catalogoService.descargarLotes();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar lotes')),
              );
            }
          }

          final countAgentes = await dbHelper.countAgentes();
          if (countAgentes == 0) {
            setState(() {
              _loadingMessage = 'Descargando agentes...';
            });

            final success = await catalogoService.descargarAgentes();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar agentes')),
              );
            }
          }

          final countEstados = await dbHelper.countEstados();
          if (countEstados == 0) {
            setState(() {
              _loadingMessage = 'Descargando estados...';
            });

            final success = await catalogoService.descargarEstados();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar estados')),
              );
            }
          }

          final countDepartamentos = await dbHelper.countDepartamentos();
          if (countDepartamentos == 0) {
            setState(() {
              _loadingMessage = 'Descargando departamentos...';
            });

            final success = await catalogoService.descargarDepartamentos();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar departamentos')),
              );
            }
          }
          // 1. Para Ciudades
          final countCiudades = await dbHelper.countCiudades();
          if (countCiudades == 0) {
            setState(() {
              _loadingMessage = 'Descargando ciudades...';
            });

            final success = await catalogoService.descargarCiudades();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar ciudades')),
              );
            }
          }

          // 2. Para Costos
          final countCostos = await dbHelper.countCostos();
          if (countCostos == 0) {
            setState(() {
              _loadingMessage = 'Descargando costos...';
            });

            final success = await catalogoService.descargarCostos();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar costos')),
              );
            }
          }

          // 3. Para Submarcas
          final countSubmarcas = await dbHelper.countSubmarcas();
          if (countSubmarcas == 0) {
            setState(() {
              _loadingMessage = 'Descargando submarcas...';
            });

            final success = await catalogoService.descargarSubmarcas();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar submarcas')),
              );
            }
          }

          // 4. Para Motivos
          final countMotivos = await dbHelper.countMotivos();
          if (countMotivos == 0) {
            setState(() {
              _loadingMessage = 'Descargando motivos...';
            });

            final success = await catalogoService.descargarMotivos();
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al descargar motivos')),
              );
            }
          }

          // Obtener información del dispositivo
          setState(() {
            _loadingMessage = 'Obteniendo información del dispositivo...';
          });

          String? serial = await obtenerAndroidSN();
          if (serial == 'unknown' ||
              serial.isEmpty ||
              serial == 'No disponible') {
            serial = await obtenerAndroidID();
          } else {
            serial = 'SN' + serial;
          }

          // Navegar al menú principal
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuPrincipal()),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sesión exitosa\nSerie: $serial')),
            );
          }
        } else {
          setState(() {
            _errorMessage = 'Matrícula o contraseña incorrecta';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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

                  // Overlay de loading
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _loadingMessage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

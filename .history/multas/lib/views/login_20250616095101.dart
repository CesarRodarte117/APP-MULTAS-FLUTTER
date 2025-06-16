import 'package:flutter/material.dart';

// VIEWS
import 'package:multas/views/menu_principal.dart';

// CONTROLLERS
import 'package:device_information/device_information.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<String> obtenerAndroidId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id ?? 'No disponible';
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

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final matricula = _matriculaController.text;
      final password = _passwordController.text;

      if (matricula == '666' && password == '666') {
        setState(() {
          _errorMessage = null;
        });

        String? serial = await obtenerSerialNumber();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sesión exitosa\nSerial: $serial')),
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

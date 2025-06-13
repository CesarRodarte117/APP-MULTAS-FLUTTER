import 'package:flutter/material.dart';

// VIEWS
import 'package:multas/views/login.dart';

class MenuPrincipal extends StatefulWidget {
  MenuPrincipal({Key? key}) : super(key: key);

  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _selectedIndex = 0;
  bool _obscurePassword = true;
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _login() {
    if (_formKey.currentState!.validate()) {
      final matricula = _matriculaController.text;
      final password = _passwordController.text;

      if (matricula.isEmpty || password.isEmpty) {
        // Campos vacíos
        setState(() {
          _errorMessage = 'Por favor completa todos los campos';
        });
      } else if (matricula == '666' && password == '666') {
        // Credenciales correctas - navegar a otra pantalla
        setState(() {
          _errorMessage = null;
        });
        // Aquí puedes agregar la navegación a otra pantalla
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

        // Mientras tanto, mostramos un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );
      } else {
        // Credenciales incorrectas
        setState(() {
          _errorMessage = 'Matrícula o contraseña incorrecta';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
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
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 124, 36, 57),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: Image.asset(
                              'assets/logoheroica_sin_letras.png',
                            ),
                          ),
                          Text(
                            'Menu',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: const Text(
                        'Historial',
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: _selectedIndex == 0,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: const Text(
                        'Bitácora',
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: _selectedIndex == 1,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: const Text(
                        'Ajustes',
                        style: TextStyle(color: Colors.black),
                      ),
                      selected: _selectedIndex == 2,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              // Botón de Cerrar Sesión abajo del todo
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 124, 36, 57),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

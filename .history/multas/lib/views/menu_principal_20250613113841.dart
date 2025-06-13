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

  void _login() {
    // Aquí puedes agregar la lógica de inicio de sesión
    // Por ahora, simplemente navegamos a otra pantalla
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
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
                  Column(children: [const SizedBox(height: 26)]),

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

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  int _selectedIndex = 0;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //crear menu desplegable con la opcion denuncias y informacion
            const SizedBox(height: 20), // Espaciado inicial
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/logoheroica.png'),
            ), // Espaciado inicial
            // const Text(
            //   "Denuncia Ciudadana",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Color.fromARGB(255, 124, 36, 57),
            //   ),
            // ),
            TextFormField(
              // controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Matricula',
                hintText: 'Ingresa tu matricula',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length >= 3) {
                  return 'Por favor ingresa tu matricula';
                }
                return null;
              },
            ),
            const SizedBox(height: 26), // Espaciado inicial
            TextButton(
              onPressed: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => FormDenuncia()),
                // );
              },
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
      drawer: Drawer(
        child: Container(
          color: Colors.white,
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
                      child: Image.asset('assets/logoheroica_sin_letras.png'),
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
                  'Multas',
                  style: TextStyle(color: Colors.black),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     //builder: (context) => ListaDenunciasScreen(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                tileColor: Colors.white,
                title: const Text('Términos y condiciones'),
                selected: _selectedIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TermsAndConditionsScreen(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

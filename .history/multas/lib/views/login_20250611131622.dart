import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: const Center(
        child: Text('Pantalla de Login 2'),
        // Aquí irán tus campos de usuario/contraseña, botón, etc.
      ),
    );
  }
}

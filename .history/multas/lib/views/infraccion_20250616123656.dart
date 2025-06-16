import 'package:flutter/material.dart';

class InfraccionView extends StatelessWidget {
  const InfraccionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infracción')),
      body: Center(child: const Text('Contenido de la vista de infracción')),
    );
  }
}

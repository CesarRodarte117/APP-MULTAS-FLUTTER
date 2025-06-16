import 'package:flutter/material.dart';

class Infraccion extends StatelessWidget {
  const Infraccion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infracción')),
      body: Center(child: const Text('Contenido de la vista de infracción')),
    );
  }
}

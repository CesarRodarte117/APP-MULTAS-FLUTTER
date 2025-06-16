import 'package:flutter/material.dart';

class Infraccion extends StatefulWidget {
  const Infraccion({super.key});

  @override
  _InfraccionState createState() => _InfraccionState();
}

class _InfraccionState extends State<Infraccion> {
  int _selectedIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infracción"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, size: 40),
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
                  // Aquí puedes agregar los campos del formulario de infracción
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

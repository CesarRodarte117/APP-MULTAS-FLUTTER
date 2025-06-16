import 'package:flutter/material.dart';

class Infraccion extends StatefulWidget {
  //vars
  final String? apartado_menu;

  /// Constructor for the Infraccion widget.
  const Infraccion({super.key, this.apartado_menu});

  @override
  _InfraccionState createState() => _InfraccionState();
}

class _InfraccionState extends State<Infraccion> {
  int _selectedIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Infracción")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header con iconos
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconHeader(Icons.person, "Infractor"),
                        _buildIconHeader(Icons.directions_car, "Vehículo"),
                        _buildIconHeader(Icons.receipt, "Infracción"),
                        _buildIconHeader(Icons.camera_alt, "Evidencia"),
                      ],
                    ),
                  ),

                  // Aquí puedes agregar los campos del formulario de infracción
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconHeader(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: Colors.blue.shade800),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

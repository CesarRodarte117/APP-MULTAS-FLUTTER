import 'package:flutter/material.dart';

class Infraccion extends StatefulWidget {
  const Infraccion({super.key, this.apartado_menu});
  final String? apartado_menu;

  @override
  _InfraccionState createState() => _InfraccionState();
}

class _InfraccionState extends State<Infraccion> {
  int _currentStep = 0; // 0=Infractor, 1=Vehículo, 2=Infracción, 3=Evidencia
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

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
                children: [
                  // Header con indicador de pasos
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStepIcon(0, Icons.person, "Infractor"),
                            _buildStepIcon(1, Icons.directions_car, "Vehículo"),
                            _buildStepIcon(2, Icons.receipt, "Infracción"),
                            _buildStepIcon(3, Icons.camera_alt, "Evidencia"),
                          ],
                        ),
                        // Flecha indicadora
                        Positioned(
                          top: -10,
                          left: (_currentStep * (MediaQuery.of(context).size.width / 4)) + 30,
                          child: const Icon(Icons.arrow_drop_up, size: 30, color: Colors.red),
                        ),
                      ],
                    ),
                  ),

                  // Contenido del formulario según el paso actual
                  _buildStepContent(),

                  // Botones de navegación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        ElevatedButton(
                          onPressed: _prevStep,
                          child: const Text("Atrás"),
                        ),
                      const Spacer(),
                      if (_currentStep < 3)
                        ElevatedButton(
                          onPressed: _nextStep,
                          child: const Text("Siguiente"),
                        ),
                      if (_currentStep == 3)
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para enviar el formulario
                          },
                          child: const Text("Enviar"),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIcon(int stepIndex, IconData icon, String label) {
    final bool isActive = stepIndex == _currentStep;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? const Color.fromARGB(255, 124, 36, 57) // Color activo
                : Colors.grey.shade300, // Color inactivo
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 30,
            color: isActive ? Colors.white : Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildInfractorForm();
      case 1:
        return _buildVehiculoForm();
      case 2:
        return _buildInfraccionForm();
      case 3:
        return _buildEvidenciaForm();
      default:
        return Container();
    }
  }

  // Ejemplo de formulario para Infractor
  Widget _buildInfractorForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Nombre del infractor"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Número de identificación"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Teléfono"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Correo electrónico"),
        ),
        // Más campos...
      ],
    );
  }

  // Ejemplo de formulario para Vehículo
  Widget _buildVehiculoForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Marca del vehículo"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Modelo del vehículo"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Color del vehículo"),
        ),
        // Más campos...
      ],
    );
  }

  // Ejemplo de formulario para Infracción
  Widget _buildInfraccionForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Tipo de infracción"),
        TextFormField(
          decoration: const InputDecoration(labelText: "Descripción"),
        ),
        // Más campos...
      ],
    );
  }

  // Ejemplo de formulario para Evidencia
  Widget _buildEvidenciaForm() {
    return Column(
      children: [
        const Text("Subir fotos de evidencia"),
        IconButton(
          icon: const Icon(Icons.camera_alt, size: 50),
          onPressed: () {
            // Lógica para tomar fotos
          },
        ),
      ],
    );
  }
}
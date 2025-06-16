import 'package:flutter/material.dart';

import 'package:multas/models/multas.dart';
import 'package:multas/models/db.dart';

class Infraccion extends StatefulWidget {
  const Infraccion({super.key, this.apartado_menu});
  final String? apartado_menu;
  List<Calles> _calles = []; // Lista para almacenar las calles
  bool _loadingCalles = false; // Estado de carga

  @override
  _InfraccionState createState() => _InfraccionState();
}

Future<void> _loadCalles() async {
  setState(() => _loadingCalles = true);
  try {
    final connection = PostgreSQLConnection(
      'db.tarkus.mx',
      5432,
      'mpiojuarez_multas_pruebas',
      username: 'tarkus',
      password: 'tarkus',
    );

    await connection.open();
    final results = await connection.query(
      'SELECT id, clave, nombre FROM calles',
    );
    await connection.close();

    setState(() {
      _calles = results
          .map((row) => Calles(id: row[0], clave: row[1], nombre: row[2]))
          .toList();
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error cargando calles: ${e.toString()}')),
    );
  } finally {
    setState(() => _loadingCalles = false);
  }
}

class _InfraccionState extends State<Infraccion> {
  int _currentStep = 0; // 0=Infractor, 1=Vehículo, 2=Infracción, 3=Evidencia

  @override
  void initState() {
    super.initState();
    if (widget.apartado_menu == "2") {
      _currentStep = 1;
    }
  }

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
                            if (widget.apartado_menu == "1")
                              _buildStepIcon(0, Icons.person, "Infractor"),

                            _buildStepIcon(1, Icons.directions_car, "Vehículo"),
                            _buildStepIcon(2, Icons.receipt, "Infracción"),
                            _buildStepIcon(3, Icons.camera_alt, "Evidencia"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contenido del formulario según el paso actual
                  _buildStepContent(),

                  // Botones de navegación (actualizados con estilo vino)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep < 3)
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                124,
                                36,
                                57,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            child: const Text(
                              "Siguiente",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        if (_currentStep == 3)
                          ElevatedButton(
                            onPressed: () {
                              // Lógica para enviar el formulario
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                124,
                                36,
                                57,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            child: const Text(
                              "Enviar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
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

  Widget _buildInfractorForm() {
    return Column(
      children: [
        // Primera fila: Número de licencia y Estado
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "N° de licencia"),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Estado de origen",
                ),
              ),
            ),
          ],
        ),

        // Nombre completo en 3 campos
        TextFormField(
          decoration: const InputDecoration(labelText: "Nombre(s)"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Apellido paterno"),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Apellido materno"),
        ),

        // Género y Edad en misma línea
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Género"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Edad"),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        // Dirección
        // Campo de calle con autocompletado
        _loadingCalles
            ? const CircularProgressIndicator()
            : TypeAheadField<Calles>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _calleController,
                  decoration: const InputDecoration(
                    labelText: 'Calle',
                    hintText: 'Escribe para buscar',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _calles
                      .where(
                        (calle) => calle.nombre!.toLowerCase().contains(
                          pattern.toLowerCase(),
                        ),
                      )
                      .toList();
                },
                itemBuilder: (context, Calle suggestion) {
                  return ListTile(
                    title: Text(suggestion.nombre ?? ''),
                    subtitle: suggestion.clave != null
                        ? Text('Clave: ${suggestion.clave}')
                        : null,
                  );
                },
                onSuggestionSelected: (Calle suggestion) {
                  _calleController.text = suggestion.nombre ?? '';
                },
                noItemsFoundBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No se encontraron calles'),
                ),
              ),

        // Números exterior e interior en misma línea
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "N° Exterior"),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "N° Interior"),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        // Colonia y CP en misma línea
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Colonia"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "C.P."),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        // Teléfono (ancho completo)
        TextFormField(
          decoration: const InputDecoration(labelText: "Teléfono"),
          keyboardType: TextInputType.phone,
        ),
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
      ],
    );
  }

  // Ejemplo de formulario para Infracción
  Widget _buildInfraccionForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Descripción de la infracción",
          ),
        ),
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

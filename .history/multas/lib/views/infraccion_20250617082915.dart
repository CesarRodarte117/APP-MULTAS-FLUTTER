import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';

class Infraccion extends StatefulWidget {
  const Infraccion({super.key, this.apartado_menu});
  final String? apartado_menu;

  @override
  _InfraccionState createState() => _InfraccionState();
}

class _InfraccionState extends State<Infraccion> {
  int _currentStep = 0; // 0=Infractor, 1=Vehículo, 2=Infracción, 3=Evidencia
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Calles> _calles = [];
  bool _loadingCalles = false;
  final TextEditingController _calleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.apartado_menu == "2") {
      _currentStep = 1;
    }
    _loadCalles();
  }

  @override
  void dispose() {
    _calleController.dispose();
    super.dispose();
  }

  Future<void> _loadCalles() async {
    setState(() => _loadingCalles = true);

    try {
      // Primero intentamos cargar de SQLite local
      var localCalles = await _dbHelper.getLocalCalles();

      // Si no hay datos locales o queremos forzar actualización
      if (localCalles.isEmpty) {
        await _dbHelper.syncCalles(); // Descarga de PostgreSQL
        localCalles = await _dbHelper.getLocalCalles();
      }

      setState(() => _calles = localCalles);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando calles: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingCalles = false);
      }
    }
  }

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
        // Fila 1: Licencia y Estado
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "N° de licencia"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Estado de origen",
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
            ),
          ],
        ),

        // Nombre completo
        TextFormField(
          decoration: const InputDecoration(labelText: "Nombre(s)"),
          validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Apellido paterno"),
          validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Apellido materno"),
        ),

        // Género y Edad
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Género"),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Edad"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
            ),
          ],
        ),

        // // Campo de calle con autocompletado
        // _loadingCalles
        //     ? const CircularProgressIndicator()
        //     : FormField<String>(
        //         validator: (value) =>
        //             value?.isEmpty ?? true ? 'Campo obligatorio' : null,
        //         builder: (formFieldState) {
        //           return Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               TypeAheadField<Calles>(
        //                 textFieldConfiguration: TextFieldConfiguration(
        //                   controller: _calleController,
        //                   decoration: InputDecoration(
        //                     labelText: 'Calle',
        //                     hintText: 'Escribe para buscar',
        //                     border: const OutlineInputBorder(),
        //                     errorText: formFieldState.errorText,
        //                   ),
        //                   onChanged: (value) {
        //                     formFieldState.didChange(value);
        //                   },
        //                 ),
        //                 suggestionsCallback: (pattern) => _calles
        //                     .where(
        //                       (calle) => calle.nombre.toLowerCase().contains(
        //                         pattern.toLowerCase(),
        //                       ),
        //                     )
        //                     .toList(),
        //                 itemBuilder: (context, calle) => ListTile(
        //                   title: Text(calle.nombre),
        //                   subtitle: calle.clave.isNotEmpty
        //                       ? Text('Clave: ${calle.clave}')
        //                       : null,
        //                 ),
        //                 onSuggestionSelected: (calle) {
        //                   _calleController.text = calle.nombre;
        //                   formFieldState.didChange(calle.nombre);
        //                 },
        //                 noItemsFoundBuilder: (context) => const Padding(
        //                   padding: EdgeInsets.all(8.0),
        //                   child: Text('No se encontraron calles'),
        //                 ),
        //               ),
        //               if (formFieldState.hasError)
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 8.0),
        //                   child: Text(
        //                     formFieldState.errorText!,
        //                     style: TextStyle(
        //                       color: Theme.of(context).colorScheme.error,
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                 ),
        //             ],
        //           );
        //         },
        //       ),
        // Números exterior e interior
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "N° Exterior"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "N° Interior (opcional)",
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        // Colonia y CP
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Colonia"),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(labelText: "C.P."),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
            ),
          ],
        ),

        // Teléfono
        TextFormField(
          decoration: const InputDecoration(labelText: "Teléfono"),
          keyboardType: TextInputType.phone,
          validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
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

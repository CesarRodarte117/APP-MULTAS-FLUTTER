import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

//catalogos
import 'package:multas/catalogos/descargar_catalogos.dart';

// Widgets
import 'package:multas/widgets/calles_widget.dart';

class Infraccion extends StatefulWidget {
  const Infraccion({super.key, this.apartado_menu});
  final String? apartado_menu;

  @override
  _InfraccionState createState() => _InfraccionState();
}

class _InfraccionState extends State<Infraccion> {
  int _currentStep = 0; // 0=Infractor, 1=Vehículo, 2=Infracción, 3=Evidencia
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Calle? _calleSeleccionada; // Variable para almacenar la calle seleccionada
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _fotoEvidencia;
  final ImagePicker _picker = ImagePicker();

  // Método para guardar foto localmente
  Future<String> _guardarFotoLocalmente(String rutaTemporal) async {
    try {
      // Obtener el directorio de documentos de la app
      final directory = await getApplicationDocumentsDirectory();

      // Obtener fecha y hora actual formateadas
      final ahora = DateTime.now();
      final fechaHora =
          '${ahora.year}${_dosDigitos(ahora.month)}${_dosDigitos(ahora.day)}_'
          '${_dosDigitos(ahora.hour)}${_dosDigitos(ahora.minute)}${_dosDigitos(ahora.second)}';

      // Crear nombre de archivo con formato: evidencia_YYYYMMDD_HHMMSS.jpg
      final nombreArchivo = 'evidencia_$fechaHora.jpg';

      // Ruta final donde se guardará la foto
      final rutaFinal = path.join(directory.path, nombreArchivo);

      // Copiar el archivo temporal a la ubicación permanente
      await File(rutaTemporal).copy(rutaFinal);

      print('FOTO GUARDADA EN: $rutaFinal');
      // Ejemplo: /data/user/0/com.example.multas/app_flutter/evidencia_20240622_143015.jpg

      return rutaFinal;
    } catch (e) {
      print('Error al guardar foto: $e');
      rethrow;
    }
  }

  // Función auxiliar para asegurar 2 dígitos (añade 0 si es necesario)
  String _dosDigitos(int numero) {
    return numero.toString().padLeft(2, '0');
  }

  // Método para tomar foto (solo permite 1)
  Future<void> _tomarFoto() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (foto != null) {
        // Mostrar un indicador de carga mientras se guarda
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        try {
          final String nuevaRuta = await _guardarFotoLocalmente(foto.path);

          if (mounted) {
            Navigator.of(context).pop(); // Cerrar el diálogo de carga
            setState(() {
              _fotoEvidencia = nuevaRuta;
            });
          }
        } catch (e) {
          if (mounted) {
            Navigator.of(context).pop(); // Cerrar el diálogo de carga
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar foto: ${e.toString()}')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al tomar foto: ${e.toString()}')),
        );
      }
    }
  }

  // Método para eliminar la foto actual
  void _eliminarFoto() {
    setState(() {
      _fotoEvidencia = null;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.apartado_menu == "2") {
      _currentStep = 1;
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

                  // Botones de navegación
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep > 0 &&
                            !(_currentStep == 1 && widget.apartado_menu != "1"))
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: ElevatedButton(
                              onPressed: _prevStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text(
                                "Atrás",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                        ElevatedButton(
                          onPressed: _currentStep == 3
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_fotoEvidencia == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Debes tomar una foto de evidencia',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // Aquí iría la lógica para guardar la infracción
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Infracción registrada con éxito',
                                        ),
                                      ),
                                    );

                                    if (mounted) Navigator.of(context).pop();
                                  }
                                }
                              : _nextStep,
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
                          child: Text(
                            _currentStep == 3 ? "Procesar" : "Siguiente",
                            style: const TextStyle(color: Colors.white),
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
    return InkWell(
      onTap: () {
        setState(() {
          _currentStep = stepIndex;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color.fromARGB(255, 124, 36, 57)
                  : Colors.grey.shade300,
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
      ),
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
    final dbHelper = DatabaseHelper();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "N° de licencia",
                    ),

                    validator: (value) =>
                        value!.isEmpty ? 'Campo obligatorio' : null,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Estado de origen",
                    ),

                    textCapitalization: TextCapitalization
                        .characters, // Capitaliza la primera letra de cada palabra
                    validator: (value) =>
                        value!.isEmpty ? 'Campo obligatorio' : null,
                  ),
                ),
              ],
            ),

            TextFormField(
              decoration: const InputDecoration(labelText: "Nombre(s)"),
              textCapitalization: TextCapitalization
                  .characters, // Capitaliza la primera letra de cada palabra
              validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Apellido paterno"),
              textCapitalization: TextCapitalization
                  .characters, // Capitaliza la primera letra de cada palabra
              validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
            ),
            TextFormField(
              textCapitalization: TextCapitalization
                  .characters, // Capitaliza la primera letra de cada palabra
              decoration: const InputDecoration(labelText: "Apellido materno"),
              validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
            ),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Género"),
                    validator: (value) =>
                        value == null ? 'Campo obligatorio' : null,
                    items: const [
                      DropdownMenuItem(value: "HOMBRE", child: Text("HOMBRE")),
                      DropdownMenuItem(value: "MUJER", child: Text("MUJER")),
                    ],
                    onChanged: (value) {
                      // Aquí puedes guardar el valor seleccionado si es necesario
                      // Ejemplo: setState(() { _generoSeleccionado = value; });
                    },
                    hint: const Text("Seleccione género"), // Texto por defecto
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

            const SizedBox(width: 10),
            CalleAutocomplete(
              dbHelper: dbHelper,
              onCalleSelected: (calle) {
                setState(() {
                  _calleSeleccionada = calle;
                });
              },
              labelText: "Calles",
              initialValue: _calleSeleccionada,
            ),

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

            TextFormField(
              decoration: const InputDecoration(labelText: "Teléfono"),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildEvidenciaForm() {
    return Column(
      children: [
        const Text(
          "Foto de evidencia",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        if (_fotoEvidencia != null)
          Column(
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.file(File(_fotoEvidencia!), fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _eliminarFoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 124, 36, 57),
                ),
                child: const Text(
                  "Eliminar foto",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          )
        else
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt, size: 24, color: Colors.white),
            label: const Text(
              "Tomar foto de evidencia",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: _tomarFoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 124, 36, 57),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),

        const SizedBox(height: 20),
        // if (_fotoEvidencia == null)
        //   const Text(
        //     "Debes tomar una foto como evidencia",
        //     style: TextStyle(color: Colors.red, fontSize: 14),
        //   ),
      ],
    );
  }
}

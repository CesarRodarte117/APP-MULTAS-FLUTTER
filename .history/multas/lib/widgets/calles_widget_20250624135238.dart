import 'package:flutter/material.dart';

//db
import 'package:multas/models/multas.dart';
import 'package:multas/models/db.dart';

// servicios
import 'package:multas/catalogos/descargar_catalogos.dart';

class CalleDropdown extends StatefulWidget {
  final ValueChanged<Calle?>? onChanged;
  final Calle? value;
  final String? labelText;
  final CatalogoService catalogoService;
  final bool showLoading;

  const CalleDropdown({
    Key? key,
    this.onChanged,
    this.value,
    this.labelText = "Calle",
    required this.catalogoService,
    this.showLoading = true,
  }) : super(key: key);

  @override
  _CalleDropdownState createState() => _CalleDropdownState();
}

class _CalleDropdownState extends State<CalleDropdown> {
  bool _loading = false;
  Calle? _selectedValue;
  late DatabaseHelper _dbHelper; // Acceso directo a la DB

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _dbHelper = DatabaseHelper(); // O pásalo por constructor si es necesario
    _loadCalles();
  }

  Future<void> _loadCalles() async {
    if (mounted) setState(() => _loading = true);

    try {
      // 1. Verificar si hay datos locales
      final count = await _dbHelper.countCalles();
      if (count == 0) {
        // 2. Si no hay datos, descargarlos
        await widget.catalogoService.descargarCalles();
      }

      // 3. Actualizar UI (Dropdown se llenará con datos de la DB en el build)
      if (mounted)
        setState(() {
          // Mantener el valor seleccionado si existe
          if (widget.value != null) {
            _selectedValue = widget.value;
          }
        });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar calles: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && widget.showLoading) {
      return const LinearProgressIndicator();
    }

    return FutureBuilder<List<Calle>>(
      future: _dbHelper.getCalles(), // Consulta directa a la DB
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay calles disponibles');
        }

        final calles = snapshot.data!;

        return DropdownButtonFormField<Calle>(
          value: _selectedValue,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(),
          ),
          items: calles.map((calle) {
            return DropdownMenuItem<Calle>(
              value: calle,
              child: Text(calle.nombre),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedValue = value);
            widget.onChanged?.call(value);
          },
          validator: (value) => value == null ? 'Seleccione una calle' : null,
        );
      },
    );
  }
}

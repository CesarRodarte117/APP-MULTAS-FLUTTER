import 'package:flutter/material.dart';

//db
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';

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
  List<Calle> _calles = [];
  bool _loading = false;
  Calle? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _loadCalles();
  }

  Future<void> _loadCalles() async {
    if (mounted) setState(() => _loading = true);

    try {
      final calles = await widget.catalogoService.descargarCalles();
      if (mounted) {
        setState(() {
          _calles = calles;
          // Mantener el valor seleccionado si existe en las nuevas calles
          if (widget.value != null &&
              _calles.any((c) => c.clave == widget.value?.clave)) {
            _selectedValue = widget.value;
          }
        });
      }
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

    return DropdownButtonFormField<Calle>(
      value: _selectedValue,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
      ),
      items: _calles.map((calle) {
        return DropdownMenuItem<Calle>(value: calle, child: Text(calle.nombre));
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedValue = value);
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      validator: (value) => value == null ? 'Seleccione una calle' : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:multas/models/multas.dart';
import 'package:multas/models/db.dart';

class CalleDropdown extends StatefulWidget {
  final ValueChanged<Calle?>? onChanged;
  final Calle? value;
  final String? labelText;
  final bool showLoading;
  final DatabaseHelper dbHelper; // Requerimos solo el DBHelper

  const CalleDropdown({
    Key? key,
    this.onChanged,
    this.value,
    this.labelText = "Calle",
    this.showLoading = true,
    required this.dbHelper, // Obligatorio desde el padre
  }) : super(key: key);

  @override
  _CalleDropdownState createState() => _CalleDropdownState();
}

class _CalleDropdownState extends State<CalleDropdown> {
  Calle? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Calle>>(
      future: widget.dbHelper.getCalles(), // Consulta directa a la DB
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.showLoading
              ? const CircularProgressIndicator()
              : const SizedBox.shrink();
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

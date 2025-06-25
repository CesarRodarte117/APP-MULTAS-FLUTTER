import 'package:flutter/material.dart';
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';

class CalleAutocomplete extends StatefulWidget {
  final DatabaseHelper dbHelper;
  final ValueChanged<Calle?> onCalleSelected;
  final String labelText;
  final Calle? initialValue;

  const CalleAutocomplete({
    Key? key,
    required this.dbHelper,
    required this.onCalleSelected,
    this.labelText = "Calles",
    this.initialValue,
  }) : super(key: key);

  @override
  _CalleAutocompleteState createState() => _CalleAutocompleteState();
}

class _CalleAutocompleteState extends State<CalleAutocomplete> {
  final TextEditingController _controller = TextEditingController();
  List<Calle> _callesFiltradas = [];
  Calle? _calleSeleccionada;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _calleSeleccionada = widget.initialValue;
      _controller.text = widget.initialValue!.nombre;
    }
  }

  Future<void> _filtrarCalles(String query) async {
    if (query.isEmpty) {
      setState(() {
        _callesFiltradas = [];
      });
      return;
    }

    final calles = await widget.dbHelper.buscarCalles(query);
    setState(() {
      _callesFiltradas = calles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      _filtrarCalles('');
                      widget.onCalleSelected(null);
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            _filtrarCalles(value);
            if (_calleSeleccionada != null &&
                _calleSeleccionada!.nombre != value) {
              _calleSeleccionada = null;
              widget.onCalleSelected(null);
            }
          },
          validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
        ),
        if (_callesFiltradas.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 3,
                ),
                child: Scrollbar(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _callesFiltradas.length,
                    itemBuilder: (context, index) {
                      final calle = _callesFiltradas[index];
                      return ListTile(
                        title: Text(calle.nombre),
                        onTap: () {
                          _controller.text = calle.nombre;
                          _calleSeleccionada = calle;
                          widget.onCalleSelected(calle);
                          setState(() {
                            _callesFiltradas = [];
                          });
                          // Cierra el teclado al seleccionar una opción
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:multas/models/db.dart';
import 'package:multas/models/multas.dart';
import 'package:flutter/material.dart';

class GenericAutocomplete<T> extends StatefulWidget {
  final Future<List<T>> Function(String) fetchItems;
  final ValueChanged<T?> onItemSelected;
  final String Function(T) itemDisplayName;
  final String labelText;
  final T? initialValue;
  final TextCapitalization textCapitalization;
  final bool required;

  const GenericAutocomplete({
    Key? key,
    required this.fetchItems,
    required this.onItemSelected,
    required this.itemDisplayName,
    this.labelText = "Buscar",
    this.initialValue,
    this.textCapitalization = TextCapitalization.characters,
    this.required = true,
  }) : super(key: key);

  @override
  _GenericAutocompleteState<T> createState() => _GenericAutocompleteState<T>();
}

class _GenericAutocompleteState<T> extends State<GenericAutocomplete<T>> {
  final TextEditingController _controller = TextEditingController();
  List<T> _filteredItems = [];
  T? _selectedItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedItem = widget.initialValue;
      _controller.text = widget.itemDisplayName(widget.initialValue as T);
    }
  }

  Future<void> _filterItems(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final items = await widget.fetchItems(query);
      setState(() {
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_filteredItems.isNotEmpty || _isLoading)
          Transform.translate(
            offset: Offset(0, -MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(widget.itemDisplayName(item)),
                          onTap: () {
                            _controller.text = widget.itemDisplayName(item);
                            _selectedItem = item;
                            widget.onItemSelected(item);
                            setState(() {
                              _filteredItems = [];
                            });
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
            ),
          ),
        TextFormField(
          controller: _controller,
          textCapitalization: widget.textCapitalization,
          decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      _filterItems('');
                      widget.onItemSelected(null);
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            _filterItems(value);
            if (_selectedItem != null &&
                widget.itemDisplayName(_selectedItem as T) != value) {
              _selectedItem = null;
              widget.onItemSelected(null);
            }
          },
          validator: widget.required
              ? (value) => value!.isEmpty ? 'Campo obligatorio' : null
              : null,
        ),
      ],
    );
  }
}

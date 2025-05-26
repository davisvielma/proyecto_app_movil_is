import 'package:flutter/material.dart';

class FiltersButton extends StatefulWidget {
  final Function(int)
  onFilterSelected; // Callback para notificar el filtro seleccionado

  const FiltersButton({super.key, required this.onFilterSelected});

  @override
  State<FiltersButton> createState() => _FiltersButtonState();
}

class _FiltersButtonState extends State<FiltersButton> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onFilterSelected(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedIndex == index ? Colors.blue : Colors.grey,
            ),
            child: Text(
              index == 0
                  ? "Días"
                  : index == 1
                  ? "Semanas"
                  : "Meses",
            ),
          ),
        );
      }),
    );
  }
}

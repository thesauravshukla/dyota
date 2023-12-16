import 'package:flutter/material.dart';

class ColorFilter extends StatelessWidget {
  final Color? selectedColor;
  final Function(Color) onColorSelect;
  final List<Color> colors;

  const ColorFilter({
    Key? key,
    this.selectedColor,
    required this.onColorSelect,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors.map((Color color) {
            return GestureDetector(
              onTap: () => onColorSelect(color),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedColor == color
                        ? Colors.red
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

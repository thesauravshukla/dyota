import 'package:flutter/material.dart';

class PriceRangeFilter extends StatelessWidget {
  final RangeValues rangeValues;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeFilter({
    Key? key,
    required this.rangeValues,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2.0,
              ),
              child: RangeSlider(
                values: rangeValues,
                min: 0,
                max: 200,
                activeColor: Colors.black,
                inactiveColor: Colors.black.withOpacity(0.3),
                divisions: 200,
                labels: RangeLabels(
                  '\$${rangeValues.start.round()}',
                  '\$${rangeValues.end.round()}',
                ),
                onChanged: onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${rangeValues.start.round()}'),
                Text('\$${rangeValues.end.round()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

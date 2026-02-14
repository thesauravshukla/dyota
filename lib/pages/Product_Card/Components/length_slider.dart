import 'package:flutter/material.dart';

class LengthSlider extends StatelessWidget {
  final List<double> allowedLengths; // List of allowed length values
  final double selectedLength;
  final ValueChanged<double> onChanged;
  final String? validationError;

  const LengthSlider({
    Key? key,
    required this.allowedLengths,
    required this.selectedLength,
    required this.onChanged,
    this.validationError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort the allowed lengths to ensure they're in ascending order
    final sortedLengths = List<double>.from(allowedLengths)..sort();

    // Find the index of the current selected length
    final currentIndex = sortedLengths.indexOf(selectedLength);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Order Length',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 8.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Theme.of(context).colorScheme.primary,
                    overlayColor: Theme.of(context).colorScheme.primary.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Theme.of(context).colorScheme.primary,
                    inactiveTickMarkColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Theme.of(context).colorScheme.primary,
                    valueIndicatorTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  child: Slider(
                    value: currentIndex.toDouble(),
                    min: 0,
                    max: (sortedLengths.length - 1).toDouble(),
                    divisions: sortedLengths.length - 1,
                    label: '${sortedLengths[currentIndex.toInt()]} m',
                    onChanged: (value) {
                      // Convert the index back to the actual length value
                      onChanged(sortedLengths[value.toInt()]);
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: sortedLengths
                        .map((length) => Column(
                              children: [
                                Text('$length m',
                                    style: TextStyle(fontSize: 12)),
                                Container(
                                    width: 1, height: 8, color: Theme.of(context).colorScheme.primary),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Current Order Length: ${selectedLength.toStringAsFixed(2)} m',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (validationError != null)
            Text(
              validationError!,
              style: TextStyle(color: Colors.red, fontSize: 10),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LengthSlider extends StatelessWidget {
  final int minOrderLength;
  final int maxOrderLength;
  final double selectedLength;
  final List<int> labels;
  final ValueChanged<double> onChanged;
  final String? validationError;

  const LengthSlider({
    Key? key,
    required this.minOrderLength,
    required this.maxOrderLength,
    required this.selectedLength,
    required this.labels,
    required this.onChanged,
    this.validationError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: Colors.black.withOpacity(0.3),
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 8.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.black,
                    overlayColor: Colors.black.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.black,
                    inactiveTickMarkColor: Colors.black.withOpacity(0.3),
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.black,
                    valueIndicatorTextStyle: TextStyle(color: Colors.white),
                  ),
                  child: Slider(
                    value: selectedLength,
                    min: minOrderLength.toDouble(),
                    max: maxOrderLength.toDouble(),
                    divisions: 50,
                    label: selectedLength.round().toString(),
                    onChanged: onChanged,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: labels
                        .map((label) => Column(
                              children: [
                                Text('$label m',
                                    style: TextStyle(fontSize: 12)),
                                Container(
                                    width: 1, height: 8, color: Colors.black),
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

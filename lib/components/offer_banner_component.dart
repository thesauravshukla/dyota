import 'package:flutter/material.dart';

class OfferBanner extends StatelessWidget {
  final String text;
  final Color? color;

  const OfferBanner({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.redAccent,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

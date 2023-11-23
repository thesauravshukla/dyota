import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onChange;

  const SectionTitle({
    Key? key,
    required this.title,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (onChange != null)
            GestureDetector(
              onTap: onChange,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

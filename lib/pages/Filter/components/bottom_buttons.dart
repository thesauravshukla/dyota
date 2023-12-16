import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback onDiscard;
  final VoidCallback onApply;

  const BottomButtons({
    Key? key,
    required this.onDiscard,
    required this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: onDiscard,
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              child:
                  const Text('Discard', style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}

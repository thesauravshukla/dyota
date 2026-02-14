import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PaymentSection extends StatelessWidget {
  final Logger _logger = Logger('PaymentSection');

  @override
  Widget build(BuildContext context) {
    _logger.info('Building PaymentSection');
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card,
                    color: Theme.of(context).colorScheme.onSurface),
                SizedBox(width: 8),
                Text('**** **** **** 3947'),
              ],
            ),
            TextButton(
              onPressed: () {
                _logger.info('Change payment method tapped');
                // TODO: Implement change payment logic
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              child: Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}

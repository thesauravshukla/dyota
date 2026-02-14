import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AddressSection extends StatelessWidget {
  final Logger _logger = Logger('AddressSection');

  @override
  Widget build(BuildContext context) {
    _logger.info('Building AddressSection');
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      elevation: 2, // A little shadow
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align items at the start of cross axis
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: 'Jane Doe\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          '3 Newbridge Court\nChino Hills, CA 91709, United States',
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _logger.info('Change address tapped');
                // TODO: Implement change address logic
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: 4.0), // Align with the first line of text
                child: Text(
                  'Change',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final Logger _logger = Logger('DetailItem');

  DetailItem({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      _logger.info('Building DetailItem with title: $title and value: $value');
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                '$title ',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      _logger.severe('Error building DetailItem', e, stackTrace);
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                'Error',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                child: Text(
                  'Failed to load',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

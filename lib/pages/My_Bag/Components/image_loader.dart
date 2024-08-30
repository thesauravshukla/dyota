import 'package:dyota/pages/My_Bag/Components/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ImageLoader extends StatelessWidget {
  final String imageLocation;
  final Widget Function(BuildContext, String) builder;
  final Logger _logger = Logger('ImageLoader');

  ImageLoader({
    Key? key,
    required this.imageLocation,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.info('Building ImageLoader for imageLocation: $imageLocation');
    return FutureBuilder<String>(
      future: getImageUrl(imageLocation),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _logger.info('Fetching image URL for imageLocation: $imageLocation');
          return Center(child: Text(''));
        } else if (snapshot.hasError) {
          _logger.severe('Error fetching image URL: ${snapshot.error}');
          throw Exception('Error fetching image URL: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          _logger.warning('No data found for imageLocation: $imageLocation');
          return Center(child: Text(''));
        }

        String imageUrl = snapshot.data!;
        _logger.info(
            'Image URL fetched successfully for imageLocation: $imageLocation');
        return builder(context, imageUrl);
      },
    );
  }
}

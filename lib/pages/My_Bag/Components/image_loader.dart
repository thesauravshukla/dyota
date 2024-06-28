import 'package:dyota/pages/My_Bag/Components/fetch_data.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  final String imageLocation;
  final Widget Function(BuildContext, String) builder;

  const ImageLoader({
    Key? key,
    required this.imageLocation,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageUrl(imageLocation),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text(''));
        }

        String imageUrl = snapshot.data!;
        return builder(context, imageUrl);
      },
    );
  }
}

import 'package:dyota/components/shared/app_image.dart';
import 'package:flutter/material.dart';

class ImageThumbnails extends StatelessWidget {
  final List<Map<String, String>> imageDetails;
  final int selectedImageIndex;
  final Function(int) onThumbnailTap;

  const ImageThumbnails({
    Key? key,
    required this.imageDetails,
    required this.selectedImageIndex,
    required this.onThumbnailTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageDetails.length, (index) {
              return GestureDetector(
                onTap: () => onThumbnailTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedImageIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: AppImage(
                    url: imageDetails[index]['imageUrl']!,
                    width: 60,
                    height: 60,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

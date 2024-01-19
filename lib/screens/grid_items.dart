import 'dart:io';
import 'package:imagescanner/screens/image_zoom_in_out.dart';
import 'package:flutter/material.dart';
import 'package:imagescanner/screens/crop_image.dart';
import 'package:imagescanner/utils/global.dart';

class GridItem extends StatelessWidget {
  final File image;
  final int index;
  final VoidCallback onDelete;
  final Function onDoubleTap;

  const GridItem(
      {super.key,
      required this.image,
      required this.index,
      required this.onDelete,
      required this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ZoomableImage(imageUrl: image.path),
          ),
        );
      },
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CropImage(index, image, _updateIndex)));
      },
      child: Stack(
        children: [
          Image.file(
            image,
            height: 200,
            width: 200,
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: IconButton(
              icon: const Icon(Icons.cancel),
              color: AppColors.colorBlack,
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }

  void _updateIndex(int index, File image) {
    onDoubleTap(index, image);
  }
}

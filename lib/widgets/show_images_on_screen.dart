import 'package:flutter/material.dart';
import 'dart:io';

class ShowImagesOnScreen extends StatelessWidget {
  const ShowImagesOnScreen({Key? key, required this.imageIndex})
      : super(key: key);
  final String? imageIndex;

  @override
  Widget build(BuildContext context) {
    if (imageIndex == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imageIndex!),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      );
      ;
    }
  }
}

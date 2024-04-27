// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// Future<Widget> generateThumbnail(File videoFile) async {
//   final uint8list = await VideoThumbnail.thumbnailData(
//     video: videoFile.path,
//     imageFormat: ImageFormat.PNG,
//     maxHeight: 200,
//     maxWidth: 200,
//     quality: 100,
//   );
//   final image = Image.memory(uint8list!, fit: BoxFit.cover);
//   return image;
// }

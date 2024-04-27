import 'package:flutter/material.dart';
import 'dart:io';
import 'package:whatsapp_status_saver/utils/snackbar.dart';

// ignore: must_be_immutable
class ImageDownloadingFBuilder extends StatelessWidget {
  ImageDownloadingFBuilder(
      {Key? key, required this.statusIndex, required this.iconState})
      : super(key: key);
  final String statusIndex;
  IconData? iconState;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        // color: Colors.transparent,
        onTap: () async {
          // downloading of vid statuses here passing to saved tab 3
          // String waStatusesDir = '/storage/emulated/0/whatsapp_status_saver';
          String waSavedStatusesDir =
              '/storage/emulated/0/whatsapp_status_saver';

          if (!Directory(waSavedStatusesDir).existsSync()) {
            Directory(waSavedStatusesDir).createSync();
          }
          // coping orig file to saved dir here
          File originalFile = File(statusIndex);
          String uriPath = Uri.parse(statusIndex).pathSegments.last;
          String newImgFile = '$waSavedStatusesDir/IMG-$uriPath';
          await originalFile.copy(newImgFile).then((_) =>
              simpleSnackBar(context, "new image[$newImgFile] is downloaded"));

          debugPrint("imgFile : $uriPath");
        },
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(
            iconState,
            size: 26,
            color: Theme.of(context).primaryColor,
          ),
        ));
  }
}

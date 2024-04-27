import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/widgets/Video_controller.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({Key? key, required this.vidPlayScreen, this.index})
      : super(key: key);

  final String vidPlayScreen;
  final int? index;

  Future<File> downloadWaStatuses() async {
    var orgWaStatusVidFile = File(vidPlayScreen);

    if (!Directory('/storage/emulated/0/whatsapp_status_saver').existsSync()) {
      Directory('/storage/emulated/0/whatsapp_status_saver')
          .createSync(recursive: true);
    }

    final curDate = DateTime.now().toString();
    final newFileName =
        '/storage/emulated/0/wa_status_saver/VIDEO-$curDate.mp4';

    var newFile = await orgWaStatusVidFile.copy(newFileName);
    return newFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        alignment: Alignment.center,
        child: VideoController(
          videoPlayerController:
              VideoPlayerController.file(File(vidPlayScreen)),
          isLooping: true,
          vidPlayScreen: vidPlayScreen,
          index: index,
        ),
      ),
    );
  }
}

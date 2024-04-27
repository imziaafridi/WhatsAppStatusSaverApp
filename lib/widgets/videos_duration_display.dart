import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDurationDisplay extends StatefulWidget {
  const VideoDurationDisplay({super.key, required this.videoPath});
  final String videoPath;
  @override
  State<VideoDurationDisplay> createState() => _VideoDurationDisplayState();
}

class _VideoDurationDisplayState extends State<VideoDurationDisplay> {
//  final ValueNotifier<Duration> _valueNotifier =
//       ValueNotifier<Duration>(Duration.zero);
  late VideoPlayerController _videoPlayerController;
  String _totaVideoDuration = '00:00';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _totaVideoDuration =
            _totalVideoDurationMethod(_videoPlayerController.value.duration);
      });
    });
    //  var  t = _videoPlayerController.value.caption;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 1.8),
          margin: EdgeInsets.only(
            left: w * 0.1,
            right: w * 0.004,
            bottom: h * 0.003,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.play_arrow,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ),
              Text(
                _totaVideoDuration,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )),
    );
  }

  String _totalVideoDurationMethod(Duration duration) {
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }
}

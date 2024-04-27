import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/provider/new_video_notifier_for_tag.dart';
import 'package:whatsapp_status_saver/widgets/videos_duration_display.dart';

import '../provider/status_data.dart';

enum PlayIconVisibility {
  visible,
  hidden,
}

class VideoController extends StatefulWidget {
  const VideoController(
      {Key? key,
      required this.videoPlayerController,
      required this.vidPlayScreen,
      this.isLooping = false,
      this.aspectRatioHandler,
      this.index})
      : super(key: key);
  final VideoPlayerController videoPlayerController;
  final bool isLooping;
  final String vidPlayScreen;
  final double? aspectRatioHandler;
  final int? index;

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  late VideoPlayerController _vidController;
  bool _isVidPlay = false;
  double skipVideoPos = 10.0;
  PlayIconVisibility _playIconVisibility = PlayIconVisibility.visible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _vidController = widget.videoPlayerController;
    _vidController.setLooping(widget.isLooping);
    _vidController.addListener(() {
      setState(() {});
    });
    _vidController.initialize().then((_) {
      setState(() {
        _vidController.play();
        _isVidPlay = true;
      });
    });
    // final getNewTagListfromStatusDataClass = StatusesDataHandlers();
    // setState(() {
    //   getNewTagListfromStatusDataClass.newTagList[widget.index!] = false;
    // });
  }

  void playPauseBtn() {
    setState(() {
      if (_isVidPlay) {
        _vidController.pause();
      } else {
        _vidController.play();
      }
      _isVidPlay = !_isVidPlay;
    });
  }

  void skipToBack() {
    var currentVidPos = _vidController.value.duration;
    var newVidDurationPos =
        currentVidPos - Duration(seconds: skipVideoPos.toInt());
    setState(() {
      _vidController.seekTo(newVidDurationPos);
    });
  }

  void skipToForward() {
    var currentVidPos = _vidController.value.duration;
    var newVidDurationPos =
        currentVidPos + Duration(seconds: skipVideoPos.toInt());
    setState(() {
      _vidController.seekTo(newVidDurationPos);
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    if (!_vidController.value.isInitialized) {
      return const Center(
          child:
              CircularProgressIndicator()); // or any placeholder widget while video is loading
    }
    return Hero(
      tag: widget.vidPlayScreen,
      child: AspectRatio(
        aspectRatio: widget.aspectRatioHandler ??
            widget.videoPlayerController.value.aspectRatio,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _playIconVisibility =
                  _playIconVisibility == PlayIconVisibility.visible
                      ? PlayIconVisibility.hidden
                      : PlayIconVisibility.visible;
            });
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              VideoPlayer(
                widget.videoPlayerController,
              ),
              // _ControlsOverlay(controller: _controller),
              AnimatedOpacity(
                opacity: _playIconVisibility == PlayIconVisibility.visible
                    ? 1.0
                    : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: skipToBack,
                        icon: Icon(
                          Icons.skip_previous,
                          size: 28,
                          color: Theme.of(context).iconTheme.color,
                        )),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      color: Theme.of(context).primaryColor,
                      elevation: 0.0,
                      child: IconButton(
                          onPressed: playPauseBtn,
                          icon: Icon(
                            _isVidPlay ? Icons.pause : Icons.play_arrow,
                            color: Theme.of(context).iconTheme.color,
                          )),
                    ),
                    IconButton(
                        onPressed: skipToForward,
                        icon: Icon(
                          Icons.skip_next,
                          size: 28,
                          color: Theme.of(context).iconTheme.color,
                        )),
                  ],
                ),
              ),
              // display videos duration
              AnimatedOpacity(
                opacity: _playIconVisibility == PlayIconVisibility.visible
                    ? 1.0
                    : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                    margin: EdgeInsets.only(
                        left: w * 0.68, bottom: h * 0.02, right: w * 0.01),
                    child: VideoDurationDisplay(
                      videoPath: widget.vidPlayScreen,
                    )),
              ),
              // display progress bar
              VideoProgressIndicator(
                widget.videoPlayerController,
                allowScrubbing: true,
                padding: const EdgeInsets.only(top: 10),
              ),
              // Consumer<VideoInfoAndTagsNotifiers>(builder: (ctx, videoData, _) {
              //   return Align(
              //     alignment: Alignment.center,
              //     child: Container(
              //         color: Colors.green,
              //         child: Text(
              //           'date:\t${videoData.vidInfo}',
              //           style: Theme.of(context).textTheme.bodyMedium,
              //         )),
              //   );
              // })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _vidController.dispose();
  }
}

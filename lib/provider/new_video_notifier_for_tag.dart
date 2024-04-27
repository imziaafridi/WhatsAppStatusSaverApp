import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

class VideoInfoAndTagsNotifiers extends ChangeNotifier {
  bool _value = false;

  void updateValues(bool newValue) {
    _value = newValue;
    notifyListeners();
  }

  bool get tagBoolNotifier => _value;

  // info for storing videoData values
  var _info = '';
  var _videoFilePath = '';
  // get video metadata such as date and time..
  void _extractDataFromVideoInfo(String videoPath) async {
    final videoInfo = FlutterVideoInfo();
    // get path from video controller
    // if (Platform.isIOS) {
    //   _videoFilePath =
    //       '/Users/User/Library/Developer/CoreSimulator/Devices/6A0D4244-1DEB-49C3-9837-C08E19DAED31/data/Media/DCIM/$videoPath.mp4';
    // // } else
    if (Platform.isAndroid) {
      _videoFilePath =
          '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses/$videoPath.mp4';
    }
    // get video data here
    var videoMetaInfo = await videoInfo.getVideoInfo(_videoFilePath);

    _info = 'date:\t${videoMetaInfo!.date!}';

    notifyListeners();
  }

  void Function(String) get getDataFromVideoInfo => _extractDataFromVideoInfo;

  String get vidInfo => _info;
}

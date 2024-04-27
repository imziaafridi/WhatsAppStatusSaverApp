import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDurationProvider with ChangeNotifier {
  String _videoDuration = 'empty';
  VModel vm = VModel();
  late VideoPlayerController _vdc;

  VideoPlayerController get _vdController {
    return VideoPlayerController.file(File(vm.scrPay!));
  }

  void _vdcPlayTimer() {
    _vdc = _vdController;
    _videoDuration = _totalVideoDuration(_vdc.value.duration);
    notifyListeners();
  }

  void get vdcPTimer => _vdcPlayTimer();

  String _totalVideoDuration(Duration duration) {
    notifyListeners();
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  String get vidTimer {
    return _videoDuration;
  }
}

class VModel {
  String? scrPay;

  VModel({this.scrPay});
}

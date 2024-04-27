import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_status_saver/provider/status_data.dart';

class VideoDownloadededStatusPersistence extends ChangeNotifier {
  Map<String, bool> downloadedVideos = {};

  final statusesHandlerClass = StatusesDataHandlers();

  Future<void> initializeDownloadedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (String videoId in statusesHandlerClass.currentStatuses) {
      bool isDownloaded = prefs.getBool('isVideoDownloaded_$videoId') ?? false;
      downloadedVideos[videoId] = isDownloaded;
    }
    notifyListeners();
  }

  Future<void> _updateDownloadedStatus(
      String videoId, bool isDownloaded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVideoDownloaded_$videoId', isDownloaded);
    if (statusesHandlerClass.savedStatuses.contains(videoId)) {
      downloadedVideos[videoId] = isDownloaded;
    }

    notifyListeners();
  }

  void handleVideoDownloaded(String videoId) {
    _updateDownloadedStatus(videoId, true);
  }

  void handleVideoDeleted(String videoId) {
    _updateDownloadedStatus(videoId, false);
  }
}

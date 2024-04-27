import 'package:shared_preferences/shared_preferences.dart';

class VideoPreferences {
  static const String videoKeyPrefix = 'video_';

  static Future<SharedPreferences> _getPreferencesInstance() async {
    return SharedPreferences.getInstance();
  }

  static Future<void> setVideoDownloadStatus(
      String videoUrl, bool isDownloaded) async {
    SharedPreferences prefs = await _getPreferencesInstance();
    await prefs.setBool(_getVideoKey(videoUrl), isDownloaded);
  }

  static Future<bool> getVideoDownloadStatus(String videoUrl) async {
    SharedPreferences prefs = await _getPreferencesInstance();
    return prefs.getBool(_getVideoKey(videoUrl)) ?? false;
  }

  static String _getVideoKey(String videoUrl) {
    return '$videoKeyPrefix$videoUrl';
  }
}

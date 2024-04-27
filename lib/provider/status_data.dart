import 'dart:io';

// get wa status data from its original source or dir
final Directory _waOrigStatusesDirectory = Directory(
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');

// get data from custom created dir
final Directory _waSavedStatusesDirectory =
    Directory('/storage/emulated/0/whatsapp_status_saver/');

class StatusesDataHandlers {
  // for original statuses tab = 2  => contains videos
  List<String> _waStatusesfromOriginalSourceAsVideos() {
    List<String> waRecendStatusesList = _waOrigStatusesDirectory
        .listSync()
        .map((video) => video.path)
        .where((element) => element.endsWith(".mp4"))
        .toList(growable: false);

    return waRecendStatusesList;
  }

  // List<bool> _newTagList() {
  //   return List.filled(_waStatusesfromOriginalSourceAsVideos().length,
  //       true); // Initially mark all videos as new
  // }

// for downloaded statuses tab = 3 => contains both (videos + images)
  List<String> _waStatusesfromCustomCreatedSourcesAsBoth() {
    final List<String> waSavedStatusesList = _waSavedStatusesDirectory
        .listSync()
        .map((item) => item.path)
        .where(
            (element) => element.endsWith(".mp4") || element.endsWith(".jpg"))
        .toList(growable: false);
    return waSavedStatusesList;
  }

  // for original statuses tab = 1  => contains Images
  List<String> _waStatusesfromOriginalSourceAsImages() {
    List<String> waRecendStatusesList = _waOrigStatusesDirectory
        .listSync()
        .map((image) => image.path)
        .where((element) => element.endsWith(".jpg"))
        .toList(growable: false);

    return waRecendStatusesList;
  }

  // creating objects of data to access it from different sources / widgets
  List<String> get currentStatusesAsImages =>
      _waStatusesfromOriginalSourceAsImages();
  List<String> get currentStatuses => _waStatusesfromOriginalSourceAsVideos();
  List<String> get savedStatuses => _waStatusesfromCustomCreatedSourcesAsBoth();
  // List<bool> get newTagList => _newTagList();
  Directory get waOrigStatusesDir => _waOrigStatusesDirectory;
  Directory get waSavedStatusesDir => _waSavedStatusesDirectory;

  //.....
  // void removeDownloadedStatus(String val) {
  // var v = List.generate(currentStatuses.length, (index) => currentStatuses.contains(val));

  // }
  String videoPath = '';
}

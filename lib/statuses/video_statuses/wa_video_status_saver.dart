import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_status_saver/provider/video_downloaded_status_persistence.dart';
import 'package:whatsapp_status_saver/utils/snackbar.dart';
import 'package:whatsapp_status_saver/widgets/video_player.dart';
import 'package:whatsapp_status_saver/widgets/videos_duration_display.dart';
import '../../provider/status_data.dart';

class WaVideoStatusSaver extends StatefulWidget {
  const WaVideoStatusSaver({
    Key? key,
  }) : super(key: key);

  @override
  State<WaVideoStatusSaver> createState() => _WaVideoStatusSaverState();
}

class _WaVideoStatusSaverState extends State<WaVideoStatusSaver> {
  List<String> newData = [];
  bool _isRefresh = false;

  Future<void> fetch() async {
    var recentStatusesDataProvider = StatusesDataHandlers();
    setState(() {
      _isRefresh = true;
    });
    await Future.delayed(const Duration(milliseconds: 3));
    var data = recentStatusesDataProvider.currentStatuses;
    if (mounted) {
      setState(() {
        newData = data;
        _isRefresh = false;
      });
    }
  }

  Future<void> refreshingData() async {
    Future.delayed(const Duration(seconds: 2));
    await fetch();
  }

  List<String?> videoThumbsList = [];

  Future<String?> _getWaVidThumbnail(String vidThumbnail) async {
    String thumbnailDirPath =
        '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/.Thumbs';
    if (!Directory(thumbnailDirPath).existsSync()) {
      Directory(thumbnailDirPath).createSync();
    }
    var extractFilePath = Uri.parse(vidThumbnail).pathSegments.last;
    var thumbnailPath = '$thumbnailDirPath/$extractFilePath.png';
    final uint8list = await VideoThumbnail.thumbnailFile(
        video: vidThumbnail,
        thumbnailPath: thumbnailPath,
        maxWidth: 130,
        imageFormat: ImageFormat.PNG,
        quality: 50);
    videoThumbsList.add(uint8list);
    return uint8list;
  }

  List<bool> newVideosTagList = [];
  final getNewTagListfromStatusDataClass = StatusesDataHandlers();
  late SharedPreferences _sp;
  Map<String, bool> downloadedVideos = {};

  // initState()
  @override
  void initState() {
    super.initState();
    fetch();
    // _loadDownloadedStatus();
    _getNewVideoTagsAsPreferences();
    // _loadDownloadedStatus();
    _videoThumbsRemoves();
    Provider.of<VideoDownloadededStatusPersistence>(context, listen: false)
        .initializeDownloadedStatus();

    // savedStatusList = List.filled(
    //     getNewTagListfromStatusDataClass.currentStatuses.length, true);
  }

// save states of new text tag for visiting videos for the first time.
  Future<void> _getNewVideoTagsAsPreferences() async {
    _sp = await SharedPreferences.getInstance();
    newVideosTagList = List.generate(
        getNewTagListfromStatusDataClass.currentStatuses.length, (index) {
      var videoPath = getNewTagListfromStatusDataClass.currentStatuses[index];
      return _sp.getBool('video:$videoPath') ?? true;
    });
  }

  Future<void> _setNewVideoTagsAsPreferences(
      String videoPath, bool isNewVideoTag) async {
    _sp = await SharedPreferences.getInstance();
    _sp.setBool('video:$videoPath', isNewVideoTag);
  }
  // bool checkTagRemover = true;

  @override
  Widget build(BuildContext context) {
    final recentStatusProvider = StatusesDataHandlers();
    var vProvider =
        Provider.of<VideoDownloadededStatusPersistence>(context, listen: false);
    // Future.delayed(Duration(seconds: 2),()=>_videoDuration(videoPath));

    if (!Directory(recentStatusProvider.waOrigStatusesDir.path).existsSync()) {
      return Center(
        child: Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Videos do not exist. Please watch statuses\nor check internet or permission",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      );
    } else {
      if (recentStatusProvider.currentStatuses.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: refreshingData,
          child: _isRefresh
              ? const Center(child: CircularProgressIndicator())
              : newData.isEmpty
                  ? const Center(child: Text('No data available'))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Recent statuses updates directed from\nWhatsApp to show it here!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: GridView.builder(
                              key: PageStorageKey(widget.key),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                                childAspectRatio: 2 / 3,
                              ),
                              itemCount:
                                  recentStatusProvider.currentStatuses.length,
                              itemBuilder: (BuildContext context, int index) {
                                final vidPath =
                                    recentStatusProvider.currentStatuses[index];
                                bool isNewVideoTag = newVideosTagList[index];

                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(
                                              vidPlayScreen: vidPath,
                                              index: index,
                                            ),
                                          ),
                                        );

                                        setState(() {
                                          newVideosTagList[index] = false;
                                          _setNewVideoTagsAsPreferences(
                                              vidPath, false);
                                        });
                                        debugPrint('pressed');
                                      },
                                      child: FutureBuilder<String?>(
                                        future: _getWaVidThumbnail(vidPath),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String?> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Hero(
                                                tag: vidPath,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(snapshot.data!),
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        //cvmInstance is CopyVidoesMethods class instance that includes copies method for files or dirs
                                        var orgWaStatusVidFile = File(vidPath);
                                        String waStatusSaverDir =
                                            '/storage/emulated/0/whatsapp_status_saver';

                                        // for waStatusSaverDir dir
                                        if (!Directory(waStatusSaverDir)
                                            .existsSync()) {
                                          Directory(waStatusSaverDir)
                                              .createSync(recursive: true);
                                        }

                                        Uri uri = Uri.parse(vidPath);
                                        String fileName = uri.pathSegments.last;

                                        String newFileName =
                                            '$waStatusSaverDir/VID-$fileName';

                                        await orgWaStatusVidFile
                                            .copy(newFileName);

                                        if (mounted) {
                                             simpleSnackBar(context,
                                              'video is saved in:\n[$newFileName]');
                                        }
                                        // status pesistence...
                                        vProvider
                                            .handleVideoDownloaded(vidPath);
                                      },
                                      child: Consumer<
                                          VideoDownloadededStatusPersistence>(
                                        builder: (context, value, child) {
                                          return Container(
                                            alignment: Alignment.topRight,
                                            padding: const EdgeInsets.only(
                                                right: 6, top: 2),
                                            child: value.downloadedVideos[
                                                        vidPath] ??
                                                    false
                                                ? Icon(
                                                    Icons.verified,
                                                    color: Colors.blue.shade600,
                                                    size: 25,
                                                  )
                                                : Icon(
                                                    Icons.cloud_download,
                                                    color: Colors.red.shade400,
                                                    size: 25,
                                                  ),
                                          );
                                        },
                                      ),
                                    ),

                                    // display videos duration here...
                                    VideoDurationDisplay(
                                      videoPath: vidPath,
                                    ),
                                    // display tag as text for new videos
                                    if (isNewVideoTag)
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 2.2),
                                            decoration: BoxDecoration(
                                                color: Colors.red.shade500),
                                            child: Text(
                                              'new',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          )),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      } else {
        return Center(
          child: Text(
            "Videos not found",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      }
    }
  }

  // late SharedPreferences prefs;
  final statusesDataList = StatusesDataHandlers();

  void _videoThumbsRemoves() {
    setState(() {
      // iterating videoThumbsList for deleting thumbs
      for (int index = 0; index < videoThumbsList.length; index++) {
        var videoThumbPath = videoThumbsList[index];
        var videoPath = statusesDataList.currentStatuses[index];
        //debugging
        debugPrint('gettiing videoThumbPath:$videoThumbPath');
        debugPrint('gettiing videoPath at same index :$videoPath');

        // making files for both...
        var videoThumbFile = File(videoThumbPath!);
        var videoFile = File(videoPath);

        if (!videoFile.existsSync() || videoFile.path.isEmpty) {
          videoThumbFile.deleteSync();
        }
      }
    });
  }

  // end of method...
}

extension PaddingExtension on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );
  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}

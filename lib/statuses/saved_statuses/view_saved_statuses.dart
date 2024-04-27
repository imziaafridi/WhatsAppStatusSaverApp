import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_status_saver/provider/status_data.dart';
import 'package:whatsapp_status_saver/provider/video_downloaded_status_persistence.dart';
import 'package:whatsapp_status_saver/utils/custom_refresh.dart';
import 'package:whatsapp_status_saver/widgets/video_player.dart';
import 'package:whatsapp_status_saver/widgets/videos_duration_display.dart';
import 'package:whatsapp_status_saver/widgets/view_images.dart';
import '../../widgets/places_icons_on_image.dart';
import '../../widgets/show_images_on_screen.dart';
import 'package:share_plus/share_plus.dart';

class ViewsSavedStatuses extends StatefulWidget {
  const ViewsSavedStatuses({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewsSavedStatuses> createState() => _ViewsSavedStatusesState();
}

class _ViewsSavedStatusesState extends State<ViewsSavedStatuses> {
  // vars declaration scope
  Set<int> selectedVidIndexList = {};
  ValueNotifier<bool> refreshingBool = ValueNotifier<bool>(false);
  List<String?> videoThumbsList = [];

  // methods scops
  Future<String?> _getWaSavedVidThumbnail(String vidThumbnail) async {
    String thumbnailDirPath =
        '/storage/emulated/0/whatsapp_status_saver/.thumbnail';
    if (!Directory(thumbnailDirPath).existsSync()) {
      Directory(thumbnailDirPath).createSync(recursive: true);
    }
    var extractFilePath = Uri.parse(vidThumbnail).pathSegments.last;
    String thumbnailPath =
        '$thumbnailDirPath/$extractFilePath.png'; // add the file extension

    try {
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: vidThumbnail,
        thumbnailPath: thumbnailPath,
        quality: 65,
      );

      videoThumbsList.add(thumbnail);

      return thumbnail;
    } catch (e) {
      debugPrint('Failed to generate thumbnail for $vidThumbnail: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider for data handeling such as recent and saved dirs from external dirs
    final downloadedStausHandler = StatusesDataHandlers().savedStatuses;

    return Scaffold(
      // backgroundColor: Colors.grey.shade300,
      body: CustomRefresh(
        isRefreshIndicates: refreshingBool,
        waImageData: downloadedStausHandler,
        child: ValueListenableBuilder(
          valueListenable: refreshingBool,
          builder: (BuildContext context, isDataRefresh, Widget? child) {
            return isDataRefresh == false
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'saved contents here if not saved any\nthen save it from recent vidoes.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      downloadedStausHandler.isEmpty
                          ? Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'saved statuses is empty, please\ndownload some contents',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 2 / 3,
                                  children: downloadedStausHandler
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    var downloadedContents =
                                        downloadedStausHandler[entry.key];
                                    var selectedValues = selectedVidIndexList
                                        .contains(entry.key);
                                    var checkAsVideo =
                                        downloadedContents.endsWith('.mp4');
                                    var checkAsImg =
                                        downloadedContents.endsWith('.jpg');

                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        if (checkAsVideo)
                                          GestureDetector(
                                            onTap: () {
                                              // play saved videos here
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayerScreen(
                                                          vidPlayScreen:
                                                              downloadedContents),
                                                ),
                                              );
                                              // debugPrint("only mp4 data : $checkVid");
                                            },
                                            onLongPress: () {
                                              // _selectingMultiIndexMethod(keyIndex);
                                              setState(() {
                                                if (selectedValues) {
                                                  selectedVidIndexList
                                                      .remove(entry.key);
                                                } else {
                                                  selectedVidIndexList
                                                      .add(entry.key);
                                                }
                                              });
                                            },
                                            child: FutureBuilder<String?>(
                                                future: _getWaSavedVidThumbnail(
                                                    downloadedContents),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<String?>
                                                        snapshot) {
                                                  if (!snapshot.hasData ||
                                                      snapshot.hasError) {
                                                    return const Text(
                                                        "data is not found");
                                                  } else if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else {
                                                    return Stack(
                                                        fit: StackFit.expand,
                                                        children: [
                                                          Hero(
                                                            tag:
                                                                downloadedContents,
                                                            child: ShowImagesOnScreen(
                                                                imageIndex:
                                                                    snapshot
                                                                        .data!),
                                                          ),
                                                        ]);
                                                  }
                                                }),
                                          ),

                                        // view images content
                                        if (checkAsImg)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewStatusImages(
                                                              statusImgIndex:
                                                                  downloadedContents)));
                                            },
                                            onLongPress: () {
                                              setState(() {
                                                if (selectedValues) {
                                                  selectedVidIndexList
                                                      .remove(entry.key);
                                                } else {
                                                  selectedVidIndexList
                                                      .add(entry.key);
                                                }
                                              });
                                            },
                                            child: ShowImagesOnScreen(
                                                imageIndex: downloadedContents),
                                          ),

                                        const PlaceIconsOnImages(
                                          icon: Icons.fullscreen_rounded,
                                          align: Alignment.topLeft,
                                        ),
                                        checkAsImg
                                            ? const PlaceIconsOnImages(
                                                icon: Icons.image,
                                                align: Alignment.bottomRight,
                                              )
                                            : VideoDurationDisplay(
                                                videoPath: downloadedContents),

                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: InkWell(
                                            onTap: () {
                                              // share functionality here...
                                              XFile xFile =
                                                  XFile(downloadedContents);

                                              if (checkAsImg) {
                                                Share.shareXFiles([xFile],
                                                    subject: 'Sharing Image',
                                                    text:
                                                        'Check out this image!');
                                              } else {
                                                Share.shareXFiles([xFile],
                                                    subject: 'Sharing video',
                                                    text:
                                                        'Check out this video from my flutter app!');
                                              }
                                            },
                                            child: Image.asset(
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? 'assets/images/share_light_blue.png'
                                                  : 'assets/images/share_dark_blue.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedVidIndexList.isNotEmpty
            ? () {
                deleteVideo();
              }
            : null,
        backgroundColor: selectedVidIndexList.isNotEmpty
            ? Theme.of(context).primaryColor
            : Colors.grey.shade600,
        child: Stack(fit: StackFit.expand, children: [
          Icon(
            Icons.delete,
            color: selectedVidIndexList.isNotEmpty ? Colors.teal : Colors.white,
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 35, bottom: 35, right: 2, top: 1),
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(left: 3, right: 6, bottom: 2),
              child: Text(
                "${selectedVidIndexList.length}/${statusHandler.savedStatuses.length}",
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // late SharedPreferences prefs;
  late SharedPreferences prefs;

  // statuses handler consists the original & saved, dir paths also contains there methods
  final statusHandler = StatusesDataHandlers();

// delete function is modified
  Future<void> deleteVideo() async {
    // Convert the selected indexes to a List and sort it in descending order
    final sortedIndexes = selectedVidIndexList.toList()
      ..sort((a, b) => b.compareTo(a));
    setState(() {
      // Remove the items from the savedStatuses list based on the selected indexes...
      for (int index in sortedIndexes) {
        deletingVideosOperation(index);
      }
      // thumbnail deleting operations
      for (var videoThumb in videoThumbsList) {
        deletingThumbsOpertaion(videoThumb);
        debugPrint("thumbnail deleting operations status:\t$videoThumb");
      }
    });
    // deleting persistence status
    for (var viPath in statusHandler.savedStatuses) {
      deleteDownloadedStatus(viPath);
      debugPrint("deleting persistence status:\t$viPath");
    }
    // clears list that contains selecting items indexes
    selectedVidIndexList.clear();
  }

  // thumbnail deleting operations...
  void deletingThumbsOpertaion(String? videoThumb) {
    try {
      if (videoThumb != null) {
        File videoFile = File(videoThumb);
        if (videoFile.existsSync()) {
          videoFile.deleteSync();
        }
      }
    } catch (e) {
      debugPrint('Failed to delete thumbnail: $videoThumb, Error: $e');
    }
  }

  // deleting videos operations...
  void deletingVideosOperation(int index) {
    // extracting video path from savedStatuses through index of sortedIndexes list
    String videoPath = statusHandler.savedStatuses[index];
    // stores videoPath in file
    File videoFilePath = File(videoPath);
    // setState for changing states accordingly

    // video file deletion...
    try {
      if (videoFilePath.existsSync()) {
        // delete the files
        videoFilePath.deleteSync();
      }
    } catch (e) {
      // handling errors here
      debugPrint("deleting videos operations status error:\t$e");
    }
    debugPrint("deleting videos operations status:\t$videoPath");
  }

  // deleting persistence status...
  void deleteDownloadedStatus(String vPath) {
    final vProvider =
        Provider.of<VideoDownloadededStatusPersistence>(context, listen: false);
    vProvider.handleVideoDeleted(vPath);
  }

  // end of methods...
}

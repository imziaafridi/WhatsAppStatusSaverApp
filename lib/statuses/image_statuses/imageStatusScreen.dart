import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp_status_saver/provider/status_data.dart';
import 'package:whatsapp_status_saver/statuses/image_statuses/future_builder_for_img_download_icon.dart';
import 'package:whatsapp_status_saver/utils/custom_refresh.dart';
import '../../widgets/view_images.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  ValueNotifier<bool> isRefreshTrue = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  String imgIconsKey = 'image_done_key';
  List<String> storeImageStatusDone = [];

  @override
  Widget build(BuildContext context) {
    var imageStatusHandler = StatusesDataHandlers();

    if (!Directory(imageStatusHandler.waOrigStatusesDir.path).existsSync()) {
      return const simpleTextWidget();
    } else {
      // if (_getWaImagesStatuses().isNotEmpty) {
      return CustomRefresh(
          waImageData: imageStatusHandler.currentStatusesAsImages,
          isRefreshIndicates: isRefreshTrue,
          child: ValueListenableBuilder(
              valueListenable: isRefreshTrue,
              builder: (context, refresh, _) {
                return refresh
                    ? const Center(child: CircularProgressIndicator())
                    : imageStatusHandler.currentStatusesAsImages.isEmpty
                        ? const Center(
                            child: Text(
                              "no data found",
                              textScaleFactor: 1.5,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Recent statuses updates directed from\nwhatsapp to show it here!.',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    padding: const EdgeInsets.all(2),
                                    children: imageStatusHandler
                                        .currentStatusesAsImages
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      var imgKey = imageStatusHandler
                                          .currentStatusesAsImages[entry.key];
                                      debugPrint(
                                          "image key : $imgKey && image val : ");
                                      return GestureDetector(
                                        onTap: () {
                                          // navigate to full screen img
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewStatusImages(
                                                      statusImgIndex:
                                                          imageStatusHandler
                                                                  .currentStatusesAsImages[
                                                              entry.key]),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Hero(
                                                  tag: imageStatusHandler
                                                          .currentStatusesAsImages[
                                                      entry.key],
                                                  child: Image.file(
                                                    File(imageStatusHandler
                                                            .currentStatusesAsImages[
                                                        entry.key]),
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    // height: 45,
                                                  )),
                                            ),
                                            //future builder
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: ImageDownloadingFBuilder(
                                                statusIndex: imageStatusHandler
                                                        .currentStatusesAsImages[
                                                    entry.key],
                                                iconState:
                                                    Icons.download_for_offline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
              }));
    }
  }
}

// ignore: camel_case_types
class simpleTextWidget extends StatelessWidget {
  const simpleTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Install WhatsApp\n',
          style: TextStyle(fontSize: 18.0),
        ),
        Text(
          "Your Friend's Status Will Be Available Here",
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}

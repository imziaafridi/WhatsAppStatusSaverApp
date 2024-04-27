import 'package:flutter/material.dart';
import '../widgets/home_widgets/custom_drawer.dart';
import '../../statuses/image_statuses/imageStatusScreen.dart';
import '../../statuses/saved_statuses/view_saved_statuses.dart';
import '../../statuses/video_statuses/wa_video_status_saver.dart';
import '../widgets/home_widgets/custom_tool_bar.dart';

class WaStatusesTabController extends StatefulWidget {
  const WaStatusesTabController({
    Key? key,
  }) : super(key: key);

  @override
  State<WaStatusesTabController> createState() =>
      _WaStatusesTabControllerState();
}

class _WaStatusesTabControllerState extends State<WaStatusesTabController>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: DefaultTabController(
        length: 3,
        // initialIndex: selectedTabIndex,
        child: Column(
          children: const [
            TabBar(
              // controller: _tabController,
              tabs: [
                Tab(
                  text: 'Recent Images\n\t\t\t\t\tcontents',
                ),
                Tab(text: 'Recent Videos\n\t\t\t\t\tcontents'),
                // tab 3
                Tab(text: '\tDownloaded\n\t\t\t\t\tContents'),
              ],

              indicatorPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
            Expanded(
              child: TabBarView(
                // controller: _tabController,
                children: [
                  // Content for Tab 1
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    // content for images tab 1
                    child: ImageScreen(),
                  ),
                  // Content for videos Tab 2
                  WaVideoStatusSaver(),
                  // tab 3
                  ViewsSavedStatuses(),
                  
                ],
              ),
            ),
          ],
        ), // Number of tabs
      ),
      appBar: const CustomAppBar(),
    );
  }
}

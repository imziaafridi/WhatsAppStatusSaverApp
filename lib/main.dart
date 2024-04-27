import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_status_saver/permission_handler.dart';
import 'package:whatsapp_status_saver/provider/new_video_notifier_for_tag.dart';
import 'package:whatsapp_status_saver/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/provider/video_downloaded_status_persistence.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoInfoAndTagsNotifiers(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoDownloadededStatusPersistence(),
        ),
      ],
      builder: (BuildContext ctx, _) {
        return Consumer<ThemeProvider?>(
          builder: (BuildContext ctx, ThemeProvider? tp, _) {
            var d = tp?.themeData;
            if (d == null) {
              return const SizedBox();
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'WhatsApp Status Saver',
              theme: tp?.themeData,
              themeMode: ThemeMode.system,
              // darkTheme: darkTheme,
              home: const PermissionHandler(),
              // routes: ,
            );
          },
        );
      },
    );
  }
}

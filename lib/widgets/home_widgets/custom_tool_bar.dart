import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import '../../provider/theme_provider.dart';
import '../../utils/consts/key_notes.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    ThemeProvider tp = ThemeProvider();
    return AppBar(
      title: const Text(
        'whatsapp status saver',
      ),
      elevation: 0.0,
      centerTitle: true,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // bottom:
      leading: GestureDetector(
        child: const Icon(
          Icons.menu,
        ),
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
      ),

      actions: [
        GestureDetector(
          onTap: () {
            // open whatsapp app
            _launchWhatsApp();
          },
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/wa_default_icon.png'
                : 'assets/images/wa_dark_icon.png',
            height: 25,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Column(
                    children: const [
                      Center(child: Text('How does it work?')),
                      Divider(
                        height: 10,
                        thickness: 1,
                        indent: 2,
                        endIndent: 4,
                      ),
                    ],
                  ),
                  content: const KeyNotesForAppUsersAsText(),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        // Close the dialog.
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(
            Icons.info,
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  void _launchWhatsApp() async {
    var waStatusScreenUrl = "whatsapp://status";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(waStatusScreenUrl),
            mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(waStatusScreenUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      throw 'Could not launch $e';
    }
    debugPrint(
        'android and ios urls = $waStatusScreenUrl , $waStatusScreenUrl');
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

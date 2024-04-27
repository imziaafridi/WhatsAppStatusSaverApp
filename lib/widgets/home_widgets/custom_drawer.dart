import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    final themeProvider = context.watch<ThemeProvider>();

    return Drawer(
        child: Container(
      decoration: const BoxDecoration(),
      child: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: size.height * 0.15,
          child: DrawerHeader(
            child: Text(
              'whatsapp status saver app',
              style: textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ListTile(
          title: const Text('Dark Theme'),
          trailing: Switch(
            value: themeProvider.switchValue!,
            onChanged: (value) {
              themeProvider.saveSwitchStatus(value);
            },
          ),
        ),
      ]),
    ));
  }
}

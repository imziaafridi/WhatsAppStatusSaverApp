import 'package:flutter/material.dart';
import 'launcher_services.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.bringToHome(context);
    // widget.tp.loadThemeAndSwitchStatus();
  }

  @override
  Widget build(BuildContext context) {
    // double size = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.teal,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/whatsapp (1).png",
              height: 55,
              width: 55,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "status saver nd link generator for whatsapp",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

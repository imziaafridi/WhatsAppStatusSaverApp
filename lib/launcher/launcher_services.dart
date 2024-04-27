import 'package:flutter/material.dart';
import 'dart:async';
import '../permission_handler.dart';

class SplashServices {
  void bringToHome(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PermissionHandler()));
    });
  }
}

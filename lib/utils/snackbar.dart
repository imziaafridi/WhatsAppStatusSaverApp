import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> simpleSnackBar(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 2),
  ));
}

import 'package:flutter/material.dart';

class KeyNotesForAppUsersAsText extends StatelessWidget {
  const KeyNotesForAppUsersAsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: const [
          TextSpan(
              text: "KeyNote01:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 17)),
          TextSpan(
              text:
                  '\twe\'re not officially connected with WhatsApp inc in any way.This App is intended to provide you with more convinient way to explore such as save, share the status videos & images cached in your device storage.'),
          TextSpan(
              text: "\nKeyNote02:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 17)),
          TextSpan(
              text: "\tpull down to refresh data if not loaded properly!."),
          TextSpan(
              text: "\nKeyNote03:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 17)),
          TextSpan(
              text:
                  '\tselect multiple items by onlong press for deleting saved content.'),
        ],
      ),
    );
  }
}

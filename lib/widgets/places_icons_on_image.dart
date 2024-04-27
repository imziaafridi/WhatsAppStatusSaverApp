import 'package:flutter/material.dart';

class PlaceIconsOnImages extends StatelessWidget {
  const PlaceIconsOnImages({Key? key, required this.icon, required this.align})
      : super(key: key);
  final IconData icon;
  final AlignmentGeometry align;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

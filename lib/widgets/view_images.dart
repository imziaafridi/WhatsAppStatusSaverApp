import 'package:flutter/material.dart';
import 'dart:io';

class ViewStatusImages extends StatelessWidget {
  const ViewStatusImages({Key? key, required this.statusImgIndex})
      : super(key: key);

  final String statusImgIndex;

  // Future<void> _shareImages() {
  //   return Share.share(statusImgIndex);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Hero(
        tag: statusImgIndex,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.file(
                File(
                  statusImgIndex,
                ),
                fit: BoxFit.cover,
              ),
            ),
            // Card(
            //   margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            //   color: Colors.transparent,
            //   elevation: 0.0,
            //   child: IconButton(
            //       onPressed: _shareImages,
            //       icon: const Icon(
            //         Icons.share,
            //         color: Colors.white70,
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}

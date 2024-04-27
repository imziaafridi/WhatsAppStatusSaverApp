import 'package:flutter/material.dart';

import '../models/download_status.dart';

class CustomRefresh extends StatefulWidget {
  CustomRefresh({
    Key? key,
    required this.child,
    required this.waImageData,
    required this.isRefreshIndicates,
  }) : super(key: key);
  final Widget child;
  final List<String> waImageData;
  ValueNotifier<bool> isRefreshIndicates;

  @override
  State<CustomRefresh> createState() => _CustomRefreshState();
}

class _CustomRefreshState extends State<CustomRefresh> {
  List<String> newData = [];

  Future<void> fetch() async {
    setState(() {
      widget.isRefreshIndicates.value = true;
    });

    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      newData = widget.waImageData;
      widget.isRefreshIndicates.value = false;
    });
  }

  // Future<void> refreshingData() async {
  //   await fetch();
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: fetch, child: widget.child);
  }
}

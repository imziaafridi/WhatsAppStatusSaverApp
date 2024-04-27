import 'package:flutter/material.dart';

class DataHolderNotifier {
  final ValueNotifier<bool> dataNotifier = ValueNotifier<bool>(false);

  void updateData(bool newData) {
    dataNotifier.value = newData;
  }

  final ValueNotifier<Future<void>> futureVoidNotifier =
      ValueNotifier<Future<void>>(Future.value());

  void updateFuture(Future<void> newFuture) {
    futureVoidNotifier.value = newFuture;
  }
}

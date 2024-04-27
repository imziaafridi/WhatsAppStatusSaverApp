import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_status_saver/provider/status_data.dart';

import '../utils/snackbar.dart';

class DeleteSavedStatuses {
  void deleteStatus(BuildContext ctx, List<int> selectedVidIndexList) {
    // statuses handler consists the original & saved, dir paths also contains there methods
    var statusesHandler =
        // Provider.of<StatusesDataHandlers>(context, listen: false)
        StatusesDataHandlers().savedStatuses;
    var deletingFile;

    // List<int> copy = List.from(_selectedVidIndexList);
    // Convert the selected indexes to a List and sort it in descending order
    final sortedIndexes = selectedVidIndexList.toList()
      ..sort((a, b) => b.compareTo(a));
    // Remove the items from the savedStatuses list based on the selected indexes
    for (var index in sortedIndexes) {
      // passing indexes to savedStatuses for deleting
      var deleteTheVideo = statusesHandler[index];
      var fileDeleting = File(deleteTheVideo);
      if (fileDeleting.existsSync()) {
        fileDeleting.deleteSync();
      }
      deletingFile = fileDeleting;

      // delete dowloaded check from recent statuses once vid deleted from saved statuses
    }
    selectedVidIndexList.clear();

    if (!deletingFile.existsSync()) {
      simpleSnackBar(ctx,
          'video file is successfuly deleted!from:Emulator/0/whatsapp_status_saver');
    }
  }
}

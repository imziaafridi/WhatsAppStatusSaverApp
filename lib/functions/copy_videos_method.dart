import 'dart:io';

class CopyVidoesMethod {
  File _copyVidfromOrigSourcetoCustomSource(String vidUrl) {
    var orgWaStatusVidFile = File(vidUrl);

    if (!Directory('/storage/emulated/0/whatsapp_status_saver').existsSync()) {
      Directory('/storage/emulated/0/whatsapp_status_saver')
          .createSync(recursive: true);
    }

    Uri uri = Uri.parse(vidUrl);
    String fileName = uri.pathSegments.last;

    final newFileName =
        '/storage/emulated/0/whatsapp_status_saver/VID-$fileName';

    return orgWaStatusVidFile.copySync(newFileName);
  }

  File Function(String) get copyVidfromOrigSourcetoCustomSource =>
      _copyVidfromOrigSourcetoCustomSource;

  //   Future<void> Function(String) get copyVidfromOrigSourcetoCustomSource =>
  // _copyVidfromOrigSourcetoCustomSource;
}

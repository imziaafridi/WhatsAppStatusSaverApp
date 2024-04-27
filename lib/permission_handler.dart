import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_status_saver/home/wa_statuses_tab_controller.dart';

import 'package:device_info_plus/device_info_plus.dart';

class PermissionHandler extends StatefulWidget {
  const PermissionHandler({
    Key? key,
  }) : super(key: key);

  @override
  State<PermissionHandler> createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  int? _storagePermissionCheck;
  Future<int>? _storagePermissionChecker;

  int? androidSDK;

  Future<int> _loadPermission() async {
    //Get phone SDK version first inorder to request correct permissions.

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    //
    if (androidSDK! >= 30) {
      //Check first if we already have the permissions
      final _currentStatusManaged =
          await Permission.manageExternalStorage.status;
      if (_currentStatusManaged.isGranted) {
        //Update
        return 1;
      } else {
        return 0;
      }
    } else {
      //For older phones simply request the typical storage permissions
      //Check first if we already have the permissions
      final currentStatusStorage = await Permission.storage.status;
      if (currentStatusStorage.isGranted) {
        //Update provider
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    if (androidSDK! >= 30) {
      //request management permissions for android 11 and higher devices
      final _requestStatusManaged =
          await Permission.manageExternalStorage.request();
      //Update Provider model
      if (_requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final _requestStatusStorage = await Permission.storage.request();
      //Update provider model
      if (_requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    /// PermissionStatus result = await
    /// SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    final result = await [Permission.storage].request();
    setState(() {});
    if (result[Permission.storage]!.isDenied) {
      return 0;
    } else if (result[Permission.storage]!.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await _loadPermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _storagePermissionChecker,
        builder: (context, status) {
          if (status.connectionState == ConnectionState.done) {
            if (status.hasData) {
              if (status.data == 1) {
                return WaStatusesTabController();
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.blue.shade600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Storage Permission Required',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      ElevatedButton(
                        child: const Text(
                          'Allow Storage Permission',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          _storagePermissionChecker = requestPermission();
                          setState(() {});
                        },
                      )
                    ],
                  ),
                );
              }
            } else {
              return Container(
                decoration: BoxDecoration(color: Colors.blue.shade600),
                child: const Center(
                  child: Text(
                    '''
Something went wrong.. Please uninstall and Install Again.''',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              );
            }
          } else {
            return const SizedBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

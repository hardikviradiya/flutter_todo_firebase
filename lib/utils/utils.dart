import 'dart:async';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class Utils {

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static void showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));

  static int fromDateTimeToTimeStamp(DateTime date) {
    return date.microsecondsSinceEpoch;
  }

  Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        return await AndroidId().getId() ?? "";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "";
      } else {
        throw Exception('Unsupported platform');
      }
    } catch (e) {
      print('Error getting device ID: $e');
      return '';
    }
  }

}

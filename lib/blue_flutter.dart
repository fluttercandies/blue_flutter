import 'dart:async';

import 'package:flutter/services.dart';

class BlueFlutter {
  static const MethodChannel _channel = const MethodChannel('blue_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> showToast() async {
    final String version = await _channel.invokeMethod('showToast');
    return version;
  }

  static Future<bool> isOpenBlue() async {
    final bool isOpenBlue = await _channel.invokeMethod('isOpenBlue');
    return isOpenBlue;
  }

  static Future<bool> openBlue() async {
    return await _channel.invokeMethod('openBlue');
  }

  static Future<bool> closeBlue() async {
    return await _channel.invokeMethod('closeBlue');
  }

  static Future<String> permission() async {
    return await _channel.invokeMethod('permission');
  }
}

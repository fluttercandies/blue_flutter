import 'dart:async';
import 'dart:convert';
export 'model/bonded_device_model.dart';

import 'package:blue_flutter/model/bonded_device_model.dart';
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

  static Future<bool> permission() async {
    return await _channel.invokeMethod('permission');
  }

  static Future<List<BondedDeviceModel>> getBondedDevices() async {
    String data = await _channel.invokeMethod('getBondedDevices');
    List dataList = json.decode(data);
    List<BondedDeviceModel> result = dataList.map<BondedDeviceModel>((e) {
      return BondedDeviceModel.fromJson(e);
    }).toList();
    return result;
  }
}

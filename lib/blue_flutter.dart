
import 'dart:async';

import 'package:flutter/services.dart';

class BlueFlutter {
  static const MethodChannel _channel =
      const MethodChannel('blue_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

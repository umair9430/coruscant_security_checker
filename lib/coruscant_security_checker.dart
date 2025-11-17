import 'dart:async';

import 'package:flutter/services.dart';

/// Class that provides security check function.
class CoruscantSecurityChecker {
  static const MethodChannel _channel =
      const MethodChannel('coruscant_security_checker');

  /// Check whether the device is rooted or jailBroken.
  static Future<bool> get isRooted async =>
      await _channel.invokeMethod('isRooted');

  /// Check whether the device on which the app is installed is a physical device.
  static Future<bool> get isRealDevice async =>
      await _channel.invokeMethod('isRealDevice');

  /// Check that the app is installed through the correct content service (such as Google Play or Apple Store).
  static Future<bool> get hasCorrectlyInstalled async =>
      await _channel.invokeMethod('hasCorrectlyInstalled');
}

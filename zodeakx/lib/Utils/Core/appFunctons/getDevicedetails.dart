import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/DeviceDetailsModel/DeviceDetails.dart';

/// Get device details
class GetDeviceDetails {
  /// device details for login purpose
  getDeviceDetails() async {
    if (kIsWeb) {
      var device = await constant.deviceInfo.webBrowserInfo;
      combineDeviceInfo('${device.hardwareConcurrency}', device.vendor ?? "",
          device.browserName.name);
    } else if (Platform.isAndroid) {
      var device = await constant.deviceInfo.androidInfo;
      combineDeviceInfo(
          device.id ?? "", "Android v${device.version.release}", "Android");
    } else if (Platform.isIOS) {
      var device = await constant.deviceInfo.iosInfo;
      combineDeviceInfo(
          device.identifierForVendor ?? "",
          "${device.systemName} ${device.systemVersion}",
          "${device.systemName}");
    } else if (Platform.isMacOS) {
      var device = await constant.deviceInfo.macOsInfo;
      combineDeviceInfo(
          device.systemGUID ?? "", "macOS ${device.osRelease}", "macOS}");
    } else if (Platform.isWindows) {
      var device = await constant.deviceInfo.windowsInfo;
      combineDeviceInfo(device.computerName,
          "windows ${device.systemMemoryInMegabytes}", "windows}");
    } else {
      var device = await constant.deviceInfo.linuxInfo;
      combineDeviceInfo(device.machineId ?? "",
          "${device.name} ${device.version}", "${device.name}}");
    }
  }

  combineDeviceInfo(
    String deviceID,
    String OSVersion,
    String platform,
  ) {
    constant.deviceDetails = DeviceDetails(
        browser: platform,
        platform: platform,
        os: OSVersion,
        device: deviceID,
        source: (kIsWeb) ? "web" : "mobile");
  }
}

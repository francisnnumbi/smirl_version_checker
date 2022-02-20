import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class DeviceAppInfos {
  static final _IpInfoApi ipInfo = _IpInfoApi();
  static final _DeviceInfo deviceInfo = _DeviceInfo();
  static final _AppInfo appInfo = _AppInfo();
}

class _DeviceInfo {
  static final _deviceInfoPlugin = DeviceInfoPlugin();

  Future<String> getOperatingSystem() async => Platform.operatingSystem;
  Future<String> getOperatingSystemVersion() async =>
      Platform.operatingSystemVersion;

  Future<String> getScreenResolution() async =>
      '${window.physicalSize.width} X ${window.physicalSize.height}';

  Future<String> getPhoneInfo() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      return '${info.manufacturer} - ${info.model}';
    } else if (Platform.isIOS) {
      final info = await _deviceInfoPlugin.iosInfo;
      return '${info.name} - ${info.model}';
    } else {
      throw UnimplementedError();
    }
  }

  Future<String?> getPhoneVersion() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      return info.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      final info = await _deviceInfoPlugin.iosInfo;
      return info.systemVersion;
    } else {
      throw UnimplementedError();
    }
  }
}

class _AppInfo {
  Future<Map<String, dynamic>> getInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final idName = Platform.isAndroid ? 'packageName' : 'bundleName';

    return <String, dynamic>{
      'appName': packageInfo.appName,
      idName: packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };
  }

  Future<String> getPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.packageName;
  }

  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return '${packageInfo.version}  +${packageInfo.buildNumber}';
  }
}

class _IpInfoApi {
  Future<String?> getIp() async {
    try {
      final url = Uri.parse('https://api.ipify.org');
      final response = await http.get(url);

      return response.statusCode == 200 ? response.body : null;
    } catch (_) {
      return null;
    }
  }
}

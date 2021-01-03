import 'package:flutter/material.dart';

enum Flavor { DEV, QA, PRODUCTION }

class FlavorConfig {
  final Flavor flavor;
  final String appVersion;
  final Color color;
  final int versionCode;

  static FlavorConfig _instance;

  factory FlavorConfig({
    @required Flavor flavor,
    @required String appVersion,
    @required Color color,
    @required int versionCode,
  }) {
    _instance ??=
        FlavorConfig._internal(flavor, appVersion, color, versionCode);
    return _instance;
  }

  FlavorConfig._internal(
    this.flavor,
    this.appVersion,
    this.color,
    this.versionCode,
  );

  static FlavorConfig get instance {
    return _instance;
  }

  String url() {
    var url = 'http://';
    if (isQA()) {
      url += 'qa';
    } else if (isDevelopment()) {
      url += 'dev';
    } else if (isProduction()) {
      url += '';
    }

    url += 'wmc.jsbmarine.com/api/v1';
    return url;
  }

  String updateUrl() {
    var url = 'http://';
    if (isQA()) {
      url += 'qa';
    } else if (isDevelopment()) {
      url += 'dev';
    } else if (isProduction()) {
      url += '';
    }

    url += 'wmc.jsbmarine.com/api/v1';
    return url;
  }

  static bool isProduction() => _instance.flavor == Flavor.PRODUCTION;

  static bool isDevelopment() => _instance.flavor == Flavor.DEV;

  static bool isQA() => _instance.flavor == Flavor.QA;
}

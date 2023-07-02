import 'dart:convert';

import 'package:flutter/services.dart';

enum EnvironmentType { dev, prod, test }

class Environment {
  static Environment? _instance;
  static Environment get instance => _instance!;

  Environment._(this.baseUrl, this.envType);

  final String baseUrl;
  final EnvironmentType envType;

  static void init(EnvironmentType env) async {
    String contents;
    switch (env) {
      case EnvironmentType.dev:
        contents = await rootBundle.loadString('assets/config/dev.json');
        break;
      case EnvironmentType.prod:
        contents = await rootBundle.loadString('assets/config/prod.json');
        break;
      case EnvironmentType.test:
        contents = await rootBundle.loadString('assets/config/test.json');
        break;
    }
    final json = jsonDecode(contents);
    _instance = Environment._(json['baseUrl'], env);
  }
}

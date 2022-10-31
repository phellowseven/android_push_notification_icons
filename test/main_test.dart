import 'dart:io';

import 'package:android_push_notification_icons/android.dart' as android;
import 'package:android_push_notification_icons/main.dart' as main_dart;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// Unit tests for main.dart
void main() {
  test('Android icon list is correct size', () {
    expect(android.androidNotificationIcons.length, 5);
  });

  test('pubspec.yaml file exists', () async {
    const String path = 'test/config/test_pubspec.yaml';
    final File file = File(path);
    final String yamlString = file.readAsStringSync();
    final Map yamlMap = loadYaml(yamlString);

    final Map<String, dynamic> config =
        main_dart.loadConfigFile(yamlMap, 'test');
    expect(config.length, isNotNull);
  });

  test('Incorrect pubspec.yaml path throws correct error message', () async {
    const String incorrectPath = 'test/config/test_pubspec.yam';
    final File file = File(incorrectPath);
    final String yamlString = file.readAsStringSync();
    final Map yamlMap = loadYaml(yamlString);

    expect(() => main_dart.loadConfigFile(yamlMap, 'test'),
        throwsA(const TypeMatcher<FileSystemException>()));
  });

  test('image_path is in config', () {
    final Map<String, dynamic> flutterIconsConfig = <String, dynamic>{
      'image_path': 'assets/images/icon-710x599.png',
    };
    expect(main_dart.isImagePathInConfig(flutterIconsConfig), true);
  });
}

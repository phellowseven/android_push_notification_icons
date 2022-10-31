import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'android.dart' as android_launcher_icons;
import 'constants.dart';
import 'custom_exceptions.dart';

const String helpFlag = 'help';
const String defaultConfigFilePath = 'scripts/flavored_pubspec/flavor/';
const String flavorOption = 'flavor';
const String generateAllFlag = 'all';
const String flavorConfigFilePattern = r'^(.*).yaml$';
String flavorConfigFile(String flavor) => '$flavor.yaml';

List<String> getFlavors() {
  final List<String> flavors = [];
  for (var item in Directory(defaultConfigFilePath).listSync()) {
    if (item is File) {
      final name = path.basename(item.path);
      final match = RegExp(flavorConfigFilePattern).firstMatch(name);
      if (match != null) {
        flavors.add(match.group(1)!);
      }
    }
  }
  return flavors;
}

Future<void> createIconsFromArguments(List<String> arguments) async {
  final ArgParser parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(helpFlag, abbr: 'h', help: 'Usage help', negatable: false);
  // Make default null to differentiate when it is explicitly set
  parser.addOption(
    flavorOption,
    abbr: 'f',
    help: 'Configure flavor name (<flavor name>)',
  );
  parser.addFlag(generateAllFlag,
      abbr: 'a',
      help: 'Generate all flavors in folder (default: $defaultConfigFilePath)',
      negatable: false);
  final ArgResults argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    stdout.writeln(parser.usage);
    exit(0);
  }

  // Flavors manangement
  final flavors = getFlavors();
  final hasFlavors = flavors.isNotEmpty;

  if (argResults[generateAllFlag]) {
    // Create icons
    if (!hasFlavors) {
      stderr.writeln('\n✕ No flavors found (default: $defaultConfigFilePath)');
      exit(2);
    } else {
      try {
        var generationPerformed = true;
        for (String flavor in flavors) {
          print('\nFlavor: $flavor');
          generationPerformed = await generateFlavor(flavor);
        }
        if (generationPerformed) {
          print(
              '\n✓ Successfully generated push notification icons for flavors');
        } else {
          print('\n✕ Could not generate push notification icons for flavors');
        }
      } catch (e) {
        stderr.writeln(
            '\n✕ Could not generate push notification icons for flavors');
        stderr.writeln(e);
        exit(2);
      }
    }
  } else {
    final String? specificFlavor = argResults[flavorOption];

    if (specificFlavor != null) {
      if (specificFlavor == flavorOption) {
        stderr.writeln('\n✕ Specify a flavor to be generated');
        exit(2);
      } else {
        try {
          bool flavorExists = false;
          for (String flavor in flavors) {
            if (flavor == specificFlavor) {
              flavorExists = true;
            }
          }
          if (flavorExists) {
            final generationPerformed = await generateFlavor(specificFlavor);
            if (generationPerformed) {
              print(
                  '\n✓ Successfully generated push notification icons for flavor: $specificFlavor');
            } else {
              print(
                  '\n✕ Could not generate push notification icons for flavor $specificFlavor');
            }
          } else {
            stderr.writeln(
                '\n✕ Could not find flavor ${flavorConfigFile(specificFlavor)} in $defaultConfigFilePath');
            exit(2);
          }
        } catch (e) {
          stderr.writeln(
              '\n✕ Could not generate push notification icons for flavor $specificFlavor');
          stderr.writeln(e);
          exit(2);
        }
      }
    } else {
      stdout.writeln(parser.usage);
      exit(0);
    }
  }
}

Future<bool> generateFlavor(String flavor) async {
  final path = defaultConfigFilePath + flavorConfigFile(flavor);
  final File file = File(path);
  final String yamlString = file.readAsStringSync();
  final Map yamlMap = loadYaml(yamlString);

  if (hasNotificationIconsSection(yamlMap, flavorConfigFile(flavor))) {
    final Map<String, dynamic> yamlConfig =
        loadConfigFile(yamlMap, flavorConfigFile(flavor));
    await createIconsFromConfig(yamlConfig, flavor);
    return true;
  }
  return false;
}

Future<void> createIconsFromConfig(Map<String, dynamic> config,
    [String? flavor]) async {
  if (!isImagePathInConfig(config)) {
    throw const InvalidConfigException(errorMissingImagePath);
  }

  android_launcher_icons.createDefaultIcons(config, flavor);
}

Map<String, dynamic> loadConfigFile(Map yamlMap, String fileOptionResult) {
  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry
      in yamlMap['android_notification_icons'].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}

bool hasNotificationIconsSection(Map yamlMap, String fileOptionResult) {
  if (!(yamlMap['android_notification_icons'] is Map)) {
    stderr.writeln(NoConfigFoundException('Config file '
        '`$fileOptionResult`'
        ' has no `android_notification_icons` section'));
    return false;
  }
  return true;
}

bool isImagePathInConfig(Map<String, dynamic> flutterIconsConfig) {
  return flutterIconsConfig.containsKey('image_path');
}

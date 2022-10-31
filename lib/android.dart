import 'dart:io';

import 'package:image/image.dart';

import 'constants.dart' as constants;
import 'utils.dart';

class AndroidIconTemplate {
  AndroidIconTemplate({required this.size, required this.directoryName});

  final String directoryName;
  final int size;
}

final List<AndroidIconTemplate> androidNotificationIcons =
    <AndroidIconTemplate>[
  AndroidIconTemplate(directoryName: 'drawable-mdpi', size: 108),
  AndroidIconTemplate(directoryName: 'drawable-hdpi', size: 162),
  AndroidIconTemplate(directoryName: 'drawable-xhdpi', size: 216),
  AndroidIconTemplate(directoryName: 'drawable-xxhdpi', size: 324),
  AndroidIconTemplate(directoryName: 'drawable-xxxhdpi', size: 432),
];

void createDefaultIcons(
    Map<String, dynamic> flutterLauncherIconsConfig, String? flavor) {
  printStatus('Starting Android push notification icons creation');
  final String filePath = getAndroidIconPath(flutterLauncherIconsConfig);
  final Image? image = decodeImageFile(filePath);
  if (image == null) {
    return;
  }
  printStatus(
      'Creating/overwriting the push notification icons with new icons');
  for (AndroidIconTemplate template in androidNotificationIcons) {
    overwriteExistingIcons(template, image, constants.androidFileName, flavor);
  }
}

/// Overrides the existing launcher icons in the project
/// Note: Do not change interpolation unless you end up with better results (see issue for result when using cubic
/// interpolation)
void overwriteExistingIcons(
  AndroidIconTemplate template,
  Image image,
  String filename,
  String? flavor,
) {
  final Image newFile = createResizedImage(template.size, image);
  File(constants.androidResFolder(flavor) +
          template.directoryName +
          '/' +
          filename)
      .create(recursive: true)
      .then((File file) {
    file.writeAsBytesSync(encodePng(newFile));
  });
}

/// Method for the retrieval of the Android icon path
String getAndroidIconPath(Map<String, dynamic> config) {
  return config['image_path'];
}

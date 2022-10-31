String androidResFolder(String? flavor) =>
    "android/app/src/${flavor ?? 'main'}/res/";
const String androidFileName = 'local_push_notification.png';

const String errorMissingImagePath =
    'Missing "image_path" within configuration';
const String errorIncorrectIconName =
    'The icon name must contain only lowercase a-z, 0-9, or underscore: '
    'E.g. "ic_my_new_icon"';

String introMessage(String currentVersion) => '''
  ════════════════════════════════════════════
     ANDROID PUSH NOTIFICATION ICONS (v$currentVersion)                               
  ════════════════════════════════════════════
  ''';

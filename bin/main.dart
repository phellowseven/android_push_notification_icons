import 'package:android_push_notification_icons/constants.dart';
import 'package:android_push_notification_icons/main.dart'
    as android_push_notification_icons;

void main(List<String> arguments) {
  print(introMessage('0.1.0'));
  android_push_notification_icons.createIconsFromArguments(arguments);
}

import 'package:android_push_notification_icons/android.dart' as android;
import 'package:test/test.dart';

// unit tests for android.dart
void main() {
  test('Correct number of android launcher icons', () {
    expect(android.androidNotificationIcons.length, 5);
  });
}

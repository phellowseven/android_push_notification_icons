
# Android Push Notification Icons

A command-line tool which simplifies the task of updating your Android flavor push notification icons.

#### 1. Setup the config file

Add Android Push Notification Icons to dependencies.

```yaml
dev_dependencies:
  android_push_notification_icons:
    # path: ../android_push_notification_icons
    git:
      url: https://github.com/phellowseven/android_push_notification_icons.git
```

#### 2. Detailed Steps

Generate a 1024x1024px icon with transparent background, put it in `assets/app_icon` and run the dev_dependency [android_push_notification_icons](https://github.com/phellowseven/android_push_notification_icons):

Create a configuration file (if not already existing) in `scripts/flavored_pubspec/flavor`

- '\<flavor name>.yaml'
  - e.g. 'test.yaml'
- the flavor name has to relate to the actual flavor

Add the icon-path in the associated configuration file

```yaml
android_notification_icons:
  image_path: "assets/icon/icon.png"
```

Generate the icons for all flavors:

```bash
flutter pub run android_push_notification_icons:main -a
```

Generate the icons for specific flavor:

```bash
flutter pub run android_push_notification_icons:main -f <flavor name> 
- e.g. 'flutter pub run android_push_notification_icons:main -f test'
```

#### 3. Further Adaptations

- If you change the folder location of the '\<flavor name>.yaml'-file you have to adapt the file path in the library ('android_push_notification_icons') as well.

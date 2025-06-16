# App Lock Package 🔐

A lightweight and customizable Flutter package to add **biometric and passcode-based app locking** functionality to any Flutter app. This is ideal for enhancing app security and privacy with minimal setup.

## ✨ Features

- App lock using biometrics (Face ID, Touch ID, etc.)
- Fallback to PIN/passcode screen
- Supports:
  - Lock on app open
  - Lock on app resume/background
  - Lock after custom timeout
- Easy integration and configuration
- Customizable lock screen UI

## 🛠️ Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  app_lock_package:
    git:
      url: https://github.com/pranavpramod15/app_lock_package.git
```

Then run:
```bash
flutter pub get
```

## 🚀 Usage

Wrap your app with the `AppLockWrapper`:

```dart
AppLockWrapper(
  child: MyApp(),
  lockConfig: LockConfig(
    enableBiometrics: true,
    lockOnResume: true,
    lockTimeout: Duration(minutes: 1),
  ),
)
```

You can also trigger lock/unlock programmatically using the controller.

## 🔐 Lock Screen Customization

Customize the lock screen using the available builder methods:

```dart
AppLockWrapper(
  lockScreenBuilder: (context, controller) => MyCustomLockScreen(controller: controller),
  ...
)
```

## 📦 Example

See the [`example/`](https://github.com/pranavpramod15/app_lock_package/tree/main/example) folder for a working demo.

To run:
```bash
cd example
flutter run
```

## 📚 Dependencies

This package uses the following Flutter and Dart packages:

| Package | Description |
|--------|-------------|
| [`app_settings`](https://pub.dev/packages/app_settings) | Opens device settings from the app |
| [`device_info_plus`](https://pub.dev/packages/device_info_plus) | Provides detailed device info |
| [`equatable`](https://pub.dev/packages/equatable) | Simplifies value comparison in Dart classes |
| [`flutter`](https://flutter.dev) | Flutter SDK |
| [`flutter_app_lock`](https://pub.dev/packages/flutter_app_lock) | Simple app lock screen implementation |
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | State management using BLoC pattern |
| [`flutter_switch`](https://pub.dev/packages/flutter_switch) | A beautiful customizable switch widget |
| [`get_it`](https://pub.dev/packages/get_it) | Dependency injection service locator |
| [`local_auth`](https://pub.dev/packages/local_auth) | Biometric authentication |
| [`local_auth_android`](https://pub.dev/packages/local_auth_android) | Android-specific implementation for local_auth |
| [`local_auth_darwin`](https://pub.dev/packages/local_auth_darwin) | iOS/macOS implementation for local_auth |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Persistent key-value storage |
| [`url_launcher`](https://pub.dev/packages/url_launcher) | Launch URLs in a browser or web view |
| [`window_manager`](https://pub.dev/packages/window_manager) | Manage and control app windows (desktop) |

## ✅ TODO

- [ ] Add support for custom themes
- [ ] Persist failed attempts
- [ ] Unit tests

## 🧑‍💻 Author

**Pranav Pramod**  
GitHub: [@pranavpramod15](https://github.com/pranavpramod15)

---




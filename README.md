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

- [`local_auth`](https://pub.dev/packages/local_auth)
- [`shared_preferences`](https://pub.dev/packages/shared_preferences)

## ✅ TODO

- [ ] Add support for custom themes
- [ ] Persist failed attempts
- [ ] Unit tests

## 🧑‍💻 Author

**Pranav Pramod**  
GitHub: [@pranavpramod15](https://github.com/pranavpramod15)

---

> Feel free to contribute or open an issue if you find a bug or want a feature!

## 📄 License

MIT License — see [`LICENSE`](https://github.com/pranavpramod15/app_lock_package/blob/main/LICENSE) file for details.
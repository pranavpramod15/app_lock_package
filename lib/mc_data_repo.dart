import 'package:shared_preferences/shared_preferences.dart';

class McDataRepo {
  final SharedPreferences prefs;

  McDataRepo(this.prefs);

  Future<void> setAppLockStatus({required bool enableAppLock}) async {
    await prefs.setBool(AppPrefsKeys.appLockEnabled, enableAppLock);
  }

  Future<void> setAppLockMethod({required String appLockMethod}) async {
    await prefs.setString(AppPrefsKeys.appLockMethod, appLockMethod);
  }

  Future<void> setAppLockTime({required int appLockTime}) async {
    await prefs.setInt(AppPrefsKeys.appLockTime, appLockTime);
  }

  Future<void> setTimeWhenAppEnteredBackground() async {
    final int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    await prefs.setInt("setTimeWhenAppEnteredBackground", currentTime);
  }

  int getTimeWhenAppEnteredBackground() =>
      prefs.getInt("setTimeWhenAppEnteredBackground") ?? 0;

  bool getAppLockStatus() =>
      prefs.getBool(AppPrefsKeys.appLockEnabled) ?? false;

  String getAppLockMethod() =>
      prefs.getString(AppPrefsKeys.appLockMethod) ?? AppConstants.noAppLock;

  int getAppLockTime() => prefs.getInt(AppPrefsKeys.appLockTime) ?? 0;
}

class AppPrefsKeys {
  static const String appLockEnabled = 'app_lock_enabled';
  static const String appLockMethod = 'app_lock_method';
  static const String appLockTime = 'app_lock_time';
}

class AppConstants {
  static const String appLockMethodBiometric = "biometric";
  static const String appLockMethodPassword = "password";
  static const String noAppLock = "none";
  static const String deviceName = "none";
  static const String imageCropperTitle = "Move and scale";

  static const Duration immediately = Duration(minutes: 0);
  static const Duration oneMin = Duration(minutes: 1);
  static const Duration fifteenMins = Duration(minutes: 15);
  static const Duration oneHour = Duration(hours: 1);
  static const int otpSessionTime = 300;
  static const int otpResendTime = 90;
  static const int maxSmartscreenItems = 8;
  static const List websiteKeySegment = ['Web Sitesi', 'Website'];
}

import 'dart:developer';
import 'dart:io';

import 'package:app_lock/app_lock_feature/data/model/biometric_model/biometric_supported_devices.dart';
import 'package:app_lock/app_lock_feature/locator.dart';
import 'package:app_lock/mc_data_repo.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
// import 'package:local_auth_darwin/local_auth_darwin.dart';

const platform = MethodChannel('com.kobil.worksphere/biometrics');

enum BiometricTypeForApple { faceID, touchID, none }

class AuthResult {
  final bool isAvailable;
  final List<BiometricType> availableTypes;

  AuthResult({
    required this.isAvailable,
    required this.availableTypes,
  });
}

class BiometricService {
  final LocalAuthentication localAuth = LocalAuthentication();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<BiometricTypeForApple> supportedBioMetricTypeForApple() async {
    if (Platform.isMacOS) {
      return BiometricTypeForApple.touchID;
    }
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    final String machineCode = iosInfo.utsname.machine;
    if (BiometricSupportedDeviceModel.faceIdSupportedDevices.contains(
      machineCode,
    )) {
      return BiometricTypeForApple.faceID;
    } else if (BiometricSupportedDeviceModel.touchIdSupportedDevices.contains(
      machineCode,
    )) {
      return BiometricTypeForApple.touchID;
    }
    return BiometricTypeForApple.none;
  }

  Future<bool> isBiometricAppLockPossible() async {
    final canAuthenticateWithBiometrics = await localAuth.canCheckBiometrics;
    final isDeviceSupported = await localAuth.isDeviceSupported();
    final canAuthenticate = canAuthenticateWithBiometrics || isDeviceSupported;
    final isBiometricsAvailable =
        await sl<BiometricService>().isBiometricsAvailable();
    final shouldShow = await shouldShowBiometricWhenAppEntersForeground();

    return canAuthenticate && shouldShow;
  }

  Future<bool> isPasswordAppLockPossible() async {
    return (await shouldShowBiometricWhenAppEntersForeground());
  }

  Future<bool> shouldShowBiometricWhenAppEntersForeground() async {
    final backgroundTime = sl<McDataRepo>().getTimeWhenAppEnteredBackground();
    final appLockTime = sl<McDataRepo>().getAppLockTime() * 1000 * 60;
    final int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch;

    if (currentTime > ((backgroundTime + appLockTime))) {
      return true;
    }

    return false;
  }

  Future<bool> authenticate() async {
    bool? authorized;
    final isBiometricsAvailable =
        await sl<BiometricService>().isBiometricsAvailable();
    try {
      if (Platform.isMacOS) {
        authorized = await platform.invokeMethod('authenticateWithBiometrics');
      } else {
        authorized = await localAuth.authenticate(
          localizedReason: "Confirm your identity to continue.",
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: false,
            stickyAuth: true,
          ),
          authMessages: [
            const AndroidAuthMessages(
              biometricHint: "Verify identity",
              biometricNotRecognized: "Not recognized. Try again.",
              biometricRequiredTitle: "Biometric required",
              biometricSuccess: "Success",
              cancelButton: "Cancel",
              deviceCredentialsRequiredTitle: "Device credentials required",
              deviceCredentialsSetupDescription: "Device credentials required",
              goToSettingsButton: "Go to settings",
              goToSettingsDescription:
                  "Biometric authentication is not set up on your device. Go to Settings > Security to add biometric authentication.",
              signInTitle: "Authentication required",
            ),
            const IOSAuthMessages(
              lockOut:
                  "Biometric authentication is disabled. Please lock and unlock your screen to enable it.",
              goToSettingsButton: "Go to settings",
              goToSettingsDescription:
                  "Before you can select Require <Face ID / Touch ID>, you must turn on the <Face ID / Touch ID> & Passcode feature in your device settings.",
              cancelButton: "Cancel",
            ),
          ],
        );
      }
    } on PlatformException catch (e) {
      log(
        "Biometric failed with PlatformException : ${e.code.toString()}",
      );
    }

    return authorized ?? false;
  }

  Future<bool> isBiometricsAvailable() async {
    try {
      if (Platform.isMacOS) {
        return (await platform.invokeMethod('canAuthenticateWithBiometrics'));
      } else {
        return (await localAuth.getAvailableBiometrics()).isNotEmpty;
      }
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<void> openSystemSetting() async {
    if (Platform.isMacOS) {
      try {
        await platform.invokeMethod('openMacOSSystemSetting');
      } on PlatformException catch (e) {
        log(
          "Unable to open system settings macos ${e.toString()}",
        );
      }
    } else {
      const url = 'ms-settings:signinoptions';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}

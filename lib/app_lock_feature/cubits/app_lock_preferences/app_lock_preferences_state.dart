enum RequireOptions { none, immediately, minute, fifteen, hour }

enum LockType { none, password, biometric }

class AppLockPreferencesState {
  AppLockPreferencesState(
      {this.appLockActivated = false,
      this.actionTime = RequireOptions.none,
      this.lockType = LockType.none,
      this.availableBiometricOption = ""});

  final String availableBiometricOption;
  final bool appLockActivated;
  final RequireOptions actionTime;
  final LockType lockType;

  AppLockPreferencesState copyWith(
      {bool? appLockActivated,
      RequireOptions? actionTime,
      LockType? lockType,
      String? availableBiometricOption}) {
    return AppLockPreferencesState(
        appLockActivated: appLockActivated ?? this.appLockActivated,
        actionTime: actionTime ?? this.actionTime,
        lockType: lockType ?? this.lockType,
        availableBiometricOption:
            availableBiometricOption ?? this.availableBiometricOption);
  }
}

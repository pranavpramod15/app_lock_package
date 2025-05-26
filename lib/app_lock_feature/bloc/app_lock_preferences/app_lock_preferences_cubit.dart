import 'dart:io';

import 'package:app_lock/app_lock_feature/bloc/app_lock_preferences/app_lock_preferences_state.dart';
import 'package:app_lock/app_lock_feature/bloc/biometric_service/biometric_service.dart';
import 'package:app_lock/app_lock_feature/locator.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_dialog.dart';
import 'package:app_lock/mc_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLockPreferencesCubit extends Cubit<AppLockPreferencesState> {
  final McDataRepo mcDataRepo;
  final BuildContext? context;
  AppLockPreferencesCubit({required this.mcDataRepo, this.context})
      : super(AppLockPreferencesState(
            appLockActivated: false,
            actionTime: RequireOptions.none,
            lockType: LockType.none));

  void appLockSwitch(bool value) async {
    final isBiometricsAvailable =
        await sl<BiometricService>().isBiometricsAvailable();

    if (value == true) {
      await mcDataRepo.setAppLockStatus(enableAppLock: value);
      if (isBiometricsAvailable) {
        await mcDataRepo.setAppLockMethod(
            appLockMethod: AppConstants.appLockMethodBiometric);
      } else {
        await mcDataRepo.setAppLockMethod(
          appLockMethod: AppConstants.appLockMethodPassword,
        );

        await mcDataRepo.setAppLockTime(appLockTime: 0);
      }
      await updateLockState();
    } else {
      await mcDataRepo.setAppLockMethod(
        appLockMethod: AppConstants.noAppLock,
      );
      await mcDataRepo.setAppLockStatus(enableAppLock: value);
      await mcDataRepo.setAppLockTime(appLockTime: 0);
      emit(state.copyWith(
        appLockActivated: value,
        lockType: LockType.none,
        actionTime: RequireOptions.immediately,
      ));
    }
  }

  void changeAppLockType(LockType type) async {
    final isBiometricsAvailable =
        await sl<BiometricService>().isBiometricsAvailable();

    if (type == LockType.biometric) {
      if (!isBiometricsAvailable) {
        showAppLockDialog(
            context: context!,
            errorTitle: "Unable to Change",
            errorMessage: (Platform.isIOS || Platform.isMacOS)
                ? "Before you can select Require ${state.availableBiometricOption}, you must turn on ${state.availableBiometricOption} in your device settings"
                : "Before you can disable App Lock, you must set up biometric authentication or PIN in your device settings.");
        return;
      }
      await mcDataRepo.setAppLockMethod(
        appLockMethod: AppConstants.appLockMethodBiometric,
      );
      emit(state.copyWith(lockType: LockType.biometric));
    } else {
      await mcDataRepo.setAppLockMethod(
        appLockMethod: AppConstants.appLockMethodPassword,
      );
      emit(state.copyWith(lockType: LockType.password));
    }
  }

  void changeAppLockTime(int val) async {
    final RequireOptions currentOption = switch (val) {
      0 => RequireOptions.immediately,
      1 => RequireOptions.minute,
      15 => RequireOptions.fifteen,
      60 => RequireOptions.hour,
      _ => RequireOptions.immediately
    };
    await mcDataRepo.setAppLockTime(appLockTime: val);
    emit(state.copyWith(actionTime: currentOption));
  }

  Future<void> updateLockState() async {
    final bool appLockState = mcDataRepo.getAppLockStatus();

    if (appLockState) {
      final LockType applockMode =
          preferredMethod(mcDataRepo.getAppLockMethod());

      String? availableBiometricOption;
      if (Platform.isIOS || Platform.isMacOS) {
        BiometricTypeForApple biometricType =
            await sl<BiometricService>().supportedBioMetricTypeForApple();
        if (biometricType == BiometricTypeForApple.faceID) {
          availableBiometricOption = "Face ID";
        } else if (biometricType == BiometricTypeForApple.touchID) {
          availableBiometricOption = "Touch ID";
        }
      }
      availableBiometricOption ??= "Biometrics";

      emit(state.copyWith(
          appLockActivated: appLockState,
          lockType: applockMode,
          actionTime: await getAppLockTime(),
          availableBiometricOption: availableBiometricOption));
    }
  }

  Future<void> resetState() async {
    emit(AppLockPreferencesState(
      appLockActivated: false,
      actionTime: RequireOptions.none,
      lockType: LockType.none,
    ));
  }

  LockType preferredMethod(String appLockPreferredMethod) {
    return switch (appLockPreferredMethod) {
      AppConstants.appLockMethodBiometric => LockType.biometric,
      AppConstants.appLockMethodPassword => LockType.password,
      _ => LockType.none
    };
  }

  Future<RequireOptions> getAppLockTime() async {
    return switch (mcDataRepo.getAppLockTime()) {
      0 => RequireOptions.immediately,
      1 => RequireOptions.minute,
      15 => RequireOptions.fifteen,
      60 => RequireOptions.hour,
      _ => RequireOptions.immediately
    };
  }
}

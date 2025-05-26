import 'dart:io';

import 'package:app_lock/app_lock_feature/bloc/biometric_service/biometric_service.dart';
import 'package:app_lock/app_lock_feature/bloc/blur/blur_cubit.dart';
import 'package:app_lock/app_lock_feature/locator.dart';
import 'package:app_lock/mc_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> {
  final BlurCubit blurCubit;

  bool appLockInProgress = false;
  bool _isAppInBackground = false;
  bool authenticationSuccessful = false;
  AppLifecycleState previousLifecycleState = AppLifecycleState.resumed;

  AppLockCubit({required this.blurCubit}) : super(AppLockInitial());

  Future<void> appLifecycleChangedForWindows(
      AppLifecycleState lifecycleState) async {
    if (appLockInProgress) return;

    if (lifecycleState == AppLifecycleState.inactive) {
      await sl<McDataRepo>().setTimeWhenAppEnteredBackground();
      // if (await sl<McDataRepo>().appLockStatus())
      blurCubit.showBlur();

      previousLifecycleState = lifecycleState;
    } else if (lifecycleState == AppLifecycleState.resumed) {
      if (previousLifecycleState == AppLifecycleState.resumed) return;
      if (await sl<BiometricService>().isAppLockEnabled()) {
        await authenticateWithBiometrics();
        previousLifecycleState = lifecycleState;
      } else if (await sl<BiometricService>().isPasswordAppLockPossible()) {
        emit(LoginWithPassword());
      } else {
        blurCubit.removeBlur();
      }
    }
  }

  void appLifecycleIOS(AppLifecycleState lifecycleState) async {
    if (lifecycleState == AppLifecycleState.paused) {
      _isAppInBackground = true;
      authenticationSuccessful = false;
    } else if (lifecycleState == AppLifecycleState.resumed) {
      if (_isAppInBackground) {
        _isAppInBackground = !_isAppInBackground;
      }
    }
    if (appLockInProgress) return;
    if (authenticationSuccessful) {
      authenticationSuccessful = false;
      return;
    }
    if (lifecycleState == AppLifecycleState.resumed) {
      if (await sl<BiometricService>().isAppLockEnabled()) {
        await authenticateWithBiometrics();
      } else if (await sl<BiometricService>().isPasswordAppLockPossible()) {
        emit(LoginWithPassword());
      } else {
        blurCubit.removeBlur();
      }
    } else if (lifecycleState == AppLifecycleState.inactive) {
      if (previousLifecycleState == AppLifecycleState.resumed) {
        await sl<McDataRepo>().setTimeWhenAppEnteredBackground();

        blurCubit.showBlur();
      }
    }
    previousLifecycleState = lifecycleState;
  }

  void appLifecycleChangedAndroid(AppLifecycleState lifecycleState) async {
    if (appLockInProgress) {
      return;
    }
    final isBiometricAppLockPossible =
        await sl<BiometricService>().isAppLockEnabled();
    final isPasswordAppLockPossible =
        await sl<BiometricService>().isPasswordAppLockPossible();
    if (lifecycleState == AppLifecycleState.resumed) {
      await authenticateWithBiometrics();

      blurCubit.removeBlur();

      previousLifecycleState = lifecycleState;
    } else if (lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.paused) {
      if (previousLifecycleState == AppLifecycleState.resumed) {
        await sl<McDataRepo>().setTimeWhenAppEnteredBackground();
        if (sl<McDataRepo>().getAppLockStatus()) blurCubit.showBlur();
      }
      previousLifecycleState = lifecycleState;
    }
  }

  // void appLifecycleChangedMacOS(AppLifecycleState lifecycleState) async {
  //   if (lifecycleState == AppLifecycleState.paused) {
  //     sl<MasterControllerService>().suspend();
  //   } else if (lifecycleState == AppLifecycleState.resumed) {
  //     sl<MasterControllerService>().resume();
  //   }
  //   if (appLockInProgress) return;

  //   if (lifecycleState == AppLifecycleState.resumed) {
  //     if (await sl<BiometricService>().isBiometricAppLockPossible()) {
  //       await authenticateWithBiometrics(fromLoginScreen: false);
  //     } else if (await sl<BiometricService>().isPasswordAppLockPossible()) {
  //       emit(LoginWithPassword(fromLoginScreen: false));
  //     } else {
  //       blurCubit.removeBlur();
  //     }
  //     previousLifecycleState = lifecycleState;
  //   } else if (lifecycleState == AppLifecycleState.inactive) {
  //     if (previousLifecycleState == AppLifecycleState.resumed) {
  //       await sl<McDataRepo>().setTimeWhenAppEnteredBackground();
  //       if (await sl<McDataRepo>().appLockStatus()) blurCubit.showBlur();
  //     }
  //     previousLifecycleState = lifecycleState;
  //   }
  // }

  void resetState() {
    emit(AppLockInitial());
  }

  Future<void> authenticateWithBiometrics({
    String? tenantId,
    String? userId,
  }) async {
    appLockInProgress = true;
    authenticationSuccessful = false;
    if (await sl<BiometricService>().isAppLockEnabled()) {
      if (await sl<BiometricService>().authenticate()) {
        authenticationSuccessful = true;

        blurCubit.removeBlur();
      } else {
        emit(LoginWithPassword());
      }

      // To avoid life cycle call back dueto dismiss of system biometric UI
      await Future.delayed(const Duration(milliseconds: 500));
      appLockInProgress = false;
    } else {
      blurCubit.removeBlur();
      appLockInProgress = false;
      emit(AppLockFailed());
    }
  }

  Future<void> authenticateWithPassword() async {
    appLockInProgress = true;
    authenticationSuccessful = false;

    if (await sl<BiometricService>().authenticate()) {
      authenticationSuccessful = true;
      blurCubit.removeBlur();
      await Future.delayed(const Duration(milliseconds: 500));
      appLockInProgress = false;
    } else {
      blurCubit.removeBlur();
      appLockInProgress = false;
      emit(AppLockFailed());
    }
  }
}

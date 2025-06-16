import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_cubit.dart';
import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLockTypeSelectionMobile extends StatelessWidget {
  const AppLockTypeSelectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLockPreferencesCubit, AppLockPreferencesState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 1,
              indent: 0,
              height: 0,
            ),
            InkWell(
              onTap: () {
                context
                    .read<AppLockPreferencesCubit>()
                    .changeAppLockType(LockType.biometric);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Require ${state.availableBiometricOption}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 16)),
                      if (state.lockType == LockType.biometric)
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: Icon(Icons.check_circle))
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              indent: 0,
              height: 0,
            ),
            InkWell(
              onTap: () {
                context
                    .read<AppLockPreferencesCubit>()
                    .changeAppLockType(LockType.password);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: SizedBox(
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Require Password",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 16)),
                      if (state.lockType == LockType.password)
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: Icon(Icons.check_circle))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                  (state.lockType == LockType.biometric)
                      ? "You will be asked to use Face ID / Touch ID before each login.\nWhen this login option is enabled, anyone with biometrics registered on your device, or anyone recognized as you, can log into your app and view your account information. We do not store your biometric data."
                      : "You will be asked to enter your password before each login.",
                  style: Theme.of(context).textTheme.bodyMedium),
            )
          ],
        );
      },
    );
  }
}

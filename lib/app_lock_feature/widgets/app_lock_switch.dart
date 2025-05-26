import 'package:app_lock/app_lock_feature/bloc/app_lock_preferences/app_lock_preferences_cubit.dart';
import 'package:app_lock/app_lock_feature/bloc/app_lock_preferences/app_lock_preferences_state.dart';
import 'package:app_lock/app_lock_feature/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AppLockSwitch extends StatelessWidget {
  const AppLockSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLockPreferencesCubit, AppLockPreferencesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "App Lock",
                ),
                const Spacer(),
                FlutterSwitch(
                  value: state.appLockActivated,
                  padding: 4,
                  onToggle: (p0) {
                    context.read<AppLockPreferencesCubit>().appLockSwitch(p0);
                  },
                  toggleSize: 16,
                  width: 38,
                  height: 24,
                  activeColor: AppColors.primaryColor,
                  inactiveColor: AppColors.inputBorderColor,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                (state.appLockActivated == true
                    ? "You have to unlock your app with your password or ${state.availableBiometricOption}."
                    : "You will not be asked for your password every time the app starts.\nWe do not recommend using this login option if you share your device or do not lock it after each use. Enabling this option allows anyone with access to your device to log in to your app and view your account information."),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14),
              ),
            )
          ],
        );
      },
    );
  }
}

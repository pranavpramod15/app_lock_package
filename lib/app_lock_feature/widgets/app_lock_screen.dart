import 'package:app_lock/app_lock_feature/bloc/app_lock_preferences/app_lock_preferences_cubit.dart';
import 'package:app_lock/app_lock_feature/bloc/app_lock_preferences/app_lock_preferences_state.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_selection.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_switch.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_type_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacySecurityMobilScreen extends StatelessWidget {
  const PrivacySecurityMobilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLock(
        initiallyEnabled: true,
        builder: (context, launchArg) {
          return BlocBuilder<AppLockPreferencesCubit, AppLockPreferencesState>(
            builder: (context, state) {
              return SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppLockSwitch(),
                      if (state.appLockActivated)
                        const Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLockTimeSelectionMobile(),
                              Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: AppLockTypeSelectionMobile(),
                              )
                            ],
                          ),
                        ),
                    ]),
              );
            },
          );
        });
  }
}

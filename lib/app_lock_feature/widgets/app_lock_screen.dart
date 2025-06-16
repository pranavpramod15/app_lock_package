import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_cubit.dart';
import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_state.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_selection.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_switch.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_type_selection.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Lock Settings")),
      body: BlocBuilder<AppLockPreferencesCubit, AppLockPreferencesState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLockSwitch(),
                  if (state.appLockActivated)
                    const Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLockTimeSelectionMobile(),
                          SizedBox(height: 16),
                          AppLockTypeSelectionMobile(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

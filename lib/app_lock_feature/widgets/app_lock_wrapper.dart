import 'dart:io';

import 'package:app_lock/app_lock_feature/cubits/app_lock_functioanlity/app_lock_cubit.dart';
import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_cubit.dart';
import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class AppLockWrapper extends StatefulWidget {
  final Widget child;

  const AppLockWrapper({super.key, required this.child});

  @override
  State<AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends State<AppLockWrapper>
    with WidgetsBindingObserver, WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppLockCubit, AppLockState>(
          listener: _handleAppLockListener,
        )
      ],
      child: BlocBuilder<AppLockCubit, AppLockState>(
        builder: (context, state) {
          return widget.child;
        },
      ),
    );
  }

  void _handleAppLockListener(BuildContext context, AppLockState state) async {
    if (state is AppLockSuccess) {
    } else if (state is AppLockFailed) {
      context.read<AppLockCubit>().resetState();
      final preferencesCubit = context.read<AppLockPreferencesCubit>();
      preferencesCubit.changeAppLockType(LockType.password);
    } else if (state is LoginWithPassword) {
      context.read<AppLockCubit>().resetState();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("state: $state");
    if (Platform.isWindows) {
      context.read<AppLockCubit>().appLifecycleChangedForWindows(state);
    } else if (Platform.isIOS) {
      context.read<AppLockCubit>().appLifecycleIOS(state);
    } else if (Platform.isMacOS) {
      // context.read<AppLockCubit>().appLifecycleChangedMacOS(state);
    } else {
      context.read<AppLockCubit>().appLifecycleChangedAndroid(state);
    }
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // Future<void> onWindowClose() async {
  //   if (Platform.isMacOS &&
  //       context.read<AppLockCubit>().previousLifecycleState ==
  //           AppLifecycleState.resumed) {
  //     await sl<McDataRepo>().setTimeWhenAppEnteredBackground();
  //   }
  // }
}

import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_cubit.dart';
import 'package:app_lock/app_lock_feature/cubits/app_lock_preferences/app_lock_preferences_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLockTimeSelectionMobile extends StatelessWidget {
  const AppLockTimeSelectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    String actionTimeTextConverter(RequireOptions option) {
      return switch (option) {
        RequireOptions.immediately => "Immediately",
        RequireOptions.minute => "After 1 minute",
        RequireOptions.fifteen => "After 15 minutes",
        RequireOptions.hour => "After 1 hour",
        _ => "Immediately"
      };
    }

    return BlocBuilder<AppLockPreferencesCubit, AppLockPreferencesState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            final appLockCubit =
                BlocProvider.of<AppLockPreferencesCubit>(context);

            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BlocProvider.value(
                    value: appLockCubit,
                    child: _AppLockTimeSelection(),
                  );
                });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Require",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: SizedBox(
                        width: 18,
                        height: 18,
                        child: Center(child: Icon(Icons.arrow_forward_ios))),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  actionTimeTextConverter(state.actionTime),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _AppLockTimeSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const BoxDecoration overlayMobile = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16.0),
      ),
    );
    return BlocBuilder<AppLockPreferencesCubit, AppLockPreferencesState>(
      builder: (context, state) {
        return Container(
          height: 310,
          width: MediaQuery.of(context).size.width,
          decoration: overlayMobile,
          padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Require",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              selectionOption(
                isOptionSelected:
                    state.actionTime == RequireOptions.immediately,
                text: "Immediately",
                time: 0,
                context: context,
              ),
              Divider(
                thickness: 1,
                height: 0,
                indent: 0,
                color: Colors.black.withOpacity(0.08),
              ),
              selectionOption(
                isOptionSelected: state.actionTime == RequireOptions.minute,
                text: "After 1 minute",
                time: 1,
                context: context,
              ),
              Divider(
                thickness: 1,
                height: 0,
                indent: 0,
                color: Colors.black.withOpacity(0.08),
              ),
              selectionOption(
                isOptionSelected: state.actionTime == RequireOptions.fifteen,
                text: "After 15 minutes",
                time: 15,
                context: context,
              ),
              Divider(
                thickness: 1,
                height: 0,
                indent: 0,
                color: Colors.black.withOpacity(0.08),
              ),
              selectionOption(
                isOptionSelected: state.actionTime == RequireOptions.hour,
                text: "After 1 hour",
                time: 60,
                context: context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget selectionOption(
      {required String text,
      required bool isOptionSelected,
      required int time,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        BlocProvider.of<AppLockPreferencesCubit>(context)
            .changeAppLockTime(time);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              if (isOptionSelected) const Icon(Icons.check_circle)
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:app_lock/app_lock_feature/bloc/blur/blur_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlurWidget extends StatelessWidget {
  final BlurCubit blurCubit;
  final Widget child;

  const BlurWidget({
    super.key,
    required this.child,
    required this.blurCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlurCubit, BlurState>(
      bloc: blurCubit,
      buildWhen: (previous, current) => previous != current,
      builder: (BuildContext context, BlurState state) {
        if (state is BlurShown) {
          return _buildBlurWidget(context);
        }
        return child;
      },
    );
  }

  Widget _buildBlurWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: child,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
part 'blur_state.dart';

class BlurCubit extends Cubit<BlurState> {
  BlurCubit() : super(BlurDismissed());

  void showBlur() => emit(BlurShown());

  void removeBlur() => emit(BlurDismissed());
}

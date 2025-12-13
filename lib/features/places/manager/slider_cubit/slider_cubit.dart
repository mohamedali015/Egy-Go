import 'package:egy_go/features/places/manager/slider_cubit/slider_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  static SliderCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeSliderIndex(int index) {
    currentIndex = index;
    emit(SliderIndexChanged(currentIndex: currentIndex));
  }
}

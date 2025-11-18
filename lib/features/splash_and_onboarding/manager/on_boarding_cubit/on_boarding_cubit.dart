import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitialState());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  List<Map<String, String>> items = [
    {
      'image': AppAssets.onBoardingImage1,
      'title': AppStrings.onBoardingTitle1,
      'subTitle': AppStrings.onBoardingSubtitle1,
    },
    {
      'image': AppAssets.onBoardingImage2,
      'title': AppStrings.onBoardingTitle2,
      'subTitle': AppStrings.onBoardingSubtitle2,
    },
    {
      'image': AppAssets.onBoardingImage3,
      'title': AppStrings.onBoardingTitle3,
      'subTitle': AppStrings.onBoardingSubtitle3,
    },
  ];

  int currentIndex = 0;
  final PageController pageController = PageController();

  void changePage(int index) {
    currentIndex = index;
    emit(OnBoardingChangePageState());
  }

  void nextPage() {
    currentIndex++;
    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    emit(OnBoardingChangePageState());
  }
// void onBoardingTap(BuildContext context) {
//   CacheHelper.saveData(key: CacheKeys.firstTime, value: true);
//   CacheData.firstTime = true;
//
//   Navigator.pushNamedAndRemoveUntil(
//       context, LoginView.routeName, (route) => false);
// }
}

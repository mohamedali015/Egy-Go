import 'package:flutter/material.dart';

import '../../../manager/on_boarding_cubit/on_boarding_cubit.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = OnBoardingCubit.get(context);
    return PageView(
      controller: cubit.pageController,
      onPageChanged: (index) {
        cubit.changePage(index);
      },
      children: [
        Image.asset(
          cubit.items[0]['image']!,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Image.asset(
          cubit.items[1]['image']!,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Image.asset(
          cubit.items[2]['image']!,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
      ],
    );
  }
}

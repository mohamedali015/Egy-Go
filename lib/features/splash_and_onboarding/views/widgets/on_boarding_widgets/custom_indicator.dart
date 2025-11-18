import 'package:egy_go/features/splash_and_onboarding/manager/on_boarding_cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/utils/app_colors.dart';

class CustomIndicator extends StatelessWidget {
  final int currentIndex;

  const CustomIndicator({
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = OnBoardingCubit.get(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(cubit.items.length, (index) {
        final isActive = index <= currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: MyResponsive.paddingSymmetric(horizontal: 3.5),
          height: MyResponsive.height(value: 3),
          width: MyResponsive.width(value: 112),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(MyResponsive.radius(value: 10)),
          ),
        );
      }),
    );
  }
}

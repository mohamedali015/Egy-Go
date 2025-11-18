import 'package:dots_indicator/dots_indicator.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/splash_and_onboarding/manager/on_boarding_cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';

class OnBoardingContainerWidget extends StatelessWidget {
  const OnBoardingContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = OnBoardingCubit.get(context);
    return Container(
      padding: MyResponsive.paddingSymmetric(
        horizontal: 18,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Text(
            cubit.items[cubit.currentIndex]['title']!,
            style: AppTextStyles.bold20,
          ),
          SizedBox(
            height: MyResponsive.height(value: 8),
          ),
          Text(
            cubit.items[cubit.currentIndex]['subTitle']!,
            style: AppTextStyles.regular14
                .copyWith(color: AppColors.black.withValues(alpha: .5)),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: MyResponsive.height(value: 16),
          ),
          DotsIndicator(
            dotsCount: cubit.items.length,
            position: cubit.currentIndex.toDouble(),
            decorator: DotsDecorator(
              activeColor: AppColors.primary,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          CustomButton(
            title: cubit.currentIndex == cubit.items.length - 1
                ? AppStrings.getStarted
                : AppStrings.next,
            onPressed: () {
              if (cubit.currentIndex == cubit.items.length - 1) {
                // cubit.onBoardingTap(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, GetStartedView.routeName, (route) => false);
              } else {
                cubit.nextPage();
              }
            },
          )
        ],
      ),
    );
  }
}

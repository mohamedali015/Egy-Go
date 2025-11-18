import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/features/splash_and_onboarding/views/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
      },
    );
    return WidgetAnimator(
      incomingEffect: WidgetTransitionEffects.outgoingScaleUp(
        duration: const Duration(milliseconds: 1200),
      ),
      child: Center(
        child: Image.asset(
          AppAssets.splashImage,
          width: MyResponsive.width(value: 175),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

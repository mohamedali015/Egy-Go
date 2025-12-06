import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_assets.dart';
import '../manager/on_boarding_cubit/on_boarding_cubit.dart';
import 'widgets/on_boarding_widgets/on_boarding_view_body.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  static const String routeName = 'onBoarding';

  @override
  Widget build(BuildContext context) {
    precacheImage(
      const AssetImage(AppAssets.getStartedImage),
      context,
    );
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: SafeArea(
        child: Scaffold(
          body: OnBoardingViewBody(),
        ),
      ),
    );
  }
}

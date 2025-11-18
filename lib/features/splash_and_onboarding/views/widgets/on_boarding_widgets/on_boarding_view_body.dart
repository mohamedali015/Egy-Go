import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/features/splash_and_onboarding/manager/on_boarding_cubit/on_boarding_cubit.dart';
import 'package:egy_go/features/splash_and_onboarding/manager/on_boarding_cubit/on_boarding_state.dart';
import 'package:egy_go/features/splash_and_onboarding/views/widgets/on_boarding_widgets/on_boarding_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'on_boarding_page_view.dart';

class OnBoardingViewBody extends StatelessWidget {
  const OnBoardingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OnBoardingPageView(),
        Padding(
          padding: MyResponsive.paddingSymmetric(horizontal: 20),
          child: Column(
            children: [
              Spacer(),
              BlocBuilder<OnBoardingCubit, OnBoardingState>(
                builder: (context, state) {
                  return OnBoardingContainerWidget();
                },
              ),
              SizedBox(
                height: MyResponsive.height(value: 30),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

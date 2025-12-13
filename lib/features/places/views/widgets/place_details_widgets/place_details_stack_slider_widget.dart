import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/features/places/manager/slider_cubit/slider_cubit.dart';
import 'package:egy_go/features/places/manager/slider_cubit/slider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'place_details_slider.dart';

class PlaceDetailsStackSliderWidget extends StatelessWidget {
  const PlaceDetailsStackSliderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlaceDetailsSlider(),
        Positioned(
          top: MyResponsive.height(value: 30),
          left: MyResponsive.width(value: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: IconButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: AppColors.white.withValues(alpha: 0.4),
            ),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: MyResponsive.fontSize(value: 25),
            ),
          ),
        ),
        Positioned(
          top: MyResponsive.height(value: 30),
          right: MyResponsive.width(value: 15),
          child: IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: AppColors.white.withValues(alpha: 0.4),
            ),
            icon: Icon(
              Icons.favorite_border,
              size: MyResponsive.fontSize(value: 25),
            ),
          ),
        ),
        Positioned(
          bottom: MyResponsive.height(value: 15),
          left: MyResponsive.width(value: 160),
          right: 0,
          child: BlocBuilder<SliderCubit, SliderState>(
            builder: (context, state) {
              return AnimatedSmoothIndicator(
                activeIndex: SliderCubit.get(context).currentIndex,
                count: 5,
                effect: ExpandingDotsEffect(
                  dotHeight: MyResponsive.height(value: 10),
                  dotWidth: MyResponsive.width(value: 10),
                  activeDotColor: AppColors.white.withValues(alpha: .9),
                  dotColor: AppColors.white.withAlpha(51),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

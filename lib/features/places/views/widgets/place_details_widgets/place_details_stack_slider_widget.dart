import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/user/manager/user_cubit/user_cubit.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../manager/places_cubit/places_cubit.dart';
import '../../../manager/slider_cubit/slider_cubit.dart';
import '../../../manager/slider_cubit/slider_state.dart';
import 'place_details_slider.dart';

class PlaceDetailsStackSliderWidget extends StatefulWidget {
  const PlaceDetailsStackSliderWidget({
    super.key,
  });

  @override
  State<PlaceDetailsStackSliderWidget> createState() =>
      _PlaceDetailsStackSliderWidgetState();
}

class _PlaceDetailsStackSliderWidgetState
    extends State<PlaceDetailsStackSliderWidget> {
  bool favoriteLoading = false;
  @override
  Widget build(BuildContext context) {
    final userCubit = UserCubit.get(context);
    final place = PlacesCubit.get(context).selectedPlace!;

    final isFavorite = userCubit.favoritePlaces.any((p) => p.sId == place.sId);
    return Stack(
      children: [
        PlaceDetailsSlider(),
        Positioned(
          top: MyResponsive.height(value: 60),
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
          top: MyResponsive.height(value: 60),
          right: MyResponsive.width(value: 15),
          child: IconButton(
            onPressed: favoriteLoading
                ? null
                : () async {
                    setState(() => favoriteLoading = true);
                    await Future.delayed(const Duration(seconds: 2));

                    if (isFavorite) {
                      userCubit.favoritePlaces
                          .removeWhere((p) => p.sId == place.sId);
                    } else {
                      userCubit.favoritePlaces.add(place);
                    }

                    setState(() => favoriteLoading = false);
                  },
            style: IconButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: AppColors.white.withValues(alpha: 0.4),
            ),
            icon: favoriteLoading
                ? _loader()
                : Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                    size: MyResponsive.width(value: 28),
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
                count: PlacesCubit.get(context).selectedPlace!.images!.length,
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

  Widget _loader() {
    return SizedBox(
      width: MyResponsive.width(value: 22),
      height: MyResponsive.width(value: 22),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

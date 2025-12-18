import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/rating_bar_wrapper.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:flutter/material.dart';

class FirstSectionDetails extends StatelessWidget {
  const FirstSectionDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = PlacesCubit.get(context);
    var place = cubit.selectedPlace!;
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  place.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.bold20,
                ),
              ),
              SizedBox(width: MyResponsive.width(value: 6)),
              RatingBarWrapper(
                rating: 5,
                starSize: 15,
                spaceBetweenStars: 1,
              ),
              SizedBox(width: MyResponsive.width(value: 6)),
              Text(
                "(${place.rating ?? '0.0'})",
                style: AppTextStyles.semiBold14.copyWith(
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 8)),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.black.withValues(alpha: .5),
                size: MyResponsive.fontSize(value: 20),
              ),
              SizedBox(width: MyResponsive.width(value: 4)),
              Text(
                place.address ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.medium12.copyWith(
                  color: AppColors.black.withValues(alpha: .6),
                ),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 15)),
          Text(
            place.description ?? '',
            style: AppTextStyles.medium12.copyWith(
              color: AppColors.black.withValues(alpha: .6),
            ),
          ),
        ],
      ),
    );
  }
}

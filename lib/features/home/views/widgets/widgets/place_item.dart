import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/shared_widgets/rating_bar_wrapper.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MyResponsive.paddingSymmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
        border: Border.all(
          color: AppColors.black.withValues(alpha: .3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
            child: Image.asset(
              AppAssets.test,
              width: MyResponsive.width(value: 80),
              height: MyResponsive.height(value: 80),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: MyResponsive.width(value: 14),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pyramids",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.bold18,
              ),
              SizedBox(
                height: MyResponsive.height(value: 6),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.black.withValues(alpha: .6),
                    size: MyResponsive.fontSize(value: 16),
                  ),
                  SizedBox(
                    width: MyResponsive.width(value: 4),
                  ),
                  Text(
                    "Nazlet El-Samman, Al-Haram,",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppTextStyles.medium12
                        .copyWith(color: AppColors.black.withValues(alpha: .6)),
                  ),
                ],
              ),
              SizedBox(
                height: MyResponsive.height(value: 6),
              ),
              Row(
                children: [
                  RatingBarWrapper(
                    rating: 5,
                    starSize: 16,
                    spaceBetweenStars: 1,
                  ),
                  SizedBox(
                    width: MyResponsive.width(value: 6),
                  ),
                  Text(
                    "(${10})",
                    style: AppTextStyles.medium12
                        .copyWith(color: AppColors.black.withValues(alpha: .4)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

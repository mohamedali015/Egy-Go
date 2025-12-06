import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/rating_bar_wrapper.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_assets.dart';

class SpecialDiscoverMoreListViewItem extends StatelessWidget {
  const SpecialDiscoverMoreListViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          MyResponsive.radius(value: 10),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.test,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(200),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MyResponsive.height(value: 12),
            left: MyResponsive.width(value: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Giza",
                  style: AppTextStyles.bold18.copyWith(color: AppColors.white),
                ),
                SizedBox(
                  height: MyResponsive.height(value: 8),
                ),
                Row(
                  children: [
                    RatingBarWrapper(
                      rating: 4,
                      starSize: 17,
                      spaceBetweenStars: .75,
                    ),
                    SizedBox(
                      width: MyResponsive.width(value: 6),
                    ),
                    Text(
                      "(${10})",
                      style: AppTextStyles.semiBold12.copyWith(
                          color: AppColors.white.withValues(alpha: .4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

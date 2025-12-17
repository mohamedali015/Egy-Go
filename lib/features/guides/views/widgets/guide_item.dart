import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared_widgets/rating_bar_wrapper.dart';

class GuideItem extends StatelessWidget {
  const GuideItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MyResponsive.paddingSymmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      // height: MyResponsive.height(value: 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
        border: Border.all(
          color: AppColors.black.withValues(alpha: .1),
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
            child: Image.asset(
              AppAssets.test,
              width: MyResponsive.width(value: 90),
              height: MyResponsive.width(value: 90),
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: MyResponsive.width(value: 18)),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + RATING
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Mohamed Ali",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bold16,
                      ),
                    ),
                    Row(
                      children: [
                        RatingBarWrapper(
                          rating: 5,
                          starSize: 13,
                          spaceBetweenStars: 1,
                        ),
                        SizedBox(width: MyResponsive.width(value: 6)),
                        Text(
                          "(5.0)",
                          style: AppTextStyles.semiBold14.copyWith(
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: MyResponsive.height(value: 4)),

                /// DESCRIPTION
                Text(
                  "An expert in nature and wildlife.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.medium12.copyWith(
                    color: AppColors.black.withValues(alpha: .6),
                  ),
                ),

                SizedBox(height: MyResponsive.height(value: 10)),

                /// EXPERIENCE + LOCATION
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: MyResponsive.fontSize(value: 16),
                      color: Colors.amber,
                    ),
                    SizedBox(width: MyResponsive.width(value: 4)),
                    Text(
                      "10 years experience",
                      style: AppTextStyles.medium12,
                    ),
                    SizedBox(width: MyResponsive.width(value: 12)),
                    Icon(
                      Icons.location_on,
                      size: MyResponsive.fontSize(value: 16),
                      color: Colors.grey,
                    ),
                    SizedBox(width: MyResponsive.width(value: 4)),
                    Expanded(
                      child: Text(
                        "Riyadh",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.medium12,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: MyResponsive.height(value: 8)),

                /// LANGUAGES
                Row(
                  children: [
                    Icon(
                      Icons.translate,
                      size: MyResponsive.fontSize(value: 16),
                      color: Colors.grey,
                    ),
                    SizedBox(width: MyResponsive.width(value: 4)),
                    Text(
                      "Arabic, English",
                      style: AppTextStyles.medium12,
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

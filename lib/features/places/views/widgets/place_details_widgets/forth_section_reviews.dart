import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ForthSectionReviews extends StatelessWidget {
  const ForthSectionReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.reviews,
            style: AppTextStyles.bold18,
          ),
          SizedBox(height: MyResponsive.height(value: 4)),
          Row(
            children: [
              Icon(
                Icons.insert_comment_outlined,
                color: AppColors.black.withValues(alpha: .4),
                size: MyResponsive.fontSize(value: 18),
              ),
              SizedBox(width: MyResponsive.width(value: 4)),
              Text(
                'Visitors reviews reflect the guide experience!',
                style: AppTextStyles.medium12.copyWith(
                  color: AppColors.black.withValues(alpha: .5),
                ),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
        ],
      ),
    );
  }
}

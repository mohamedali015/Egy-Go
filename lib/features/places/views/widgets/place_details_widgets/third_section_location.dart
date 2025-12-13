import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class ThirdSectionLocation extends StatelessWidget {
  const ThirdSectionLocation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.location,
            style: AppTextStyles.bold18,
          ),
          SizedBox(height: MyResponsive.height(value: 4)),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.black.withValues(alpha: .4),
                size: MyResponsive.fontSize(value: 18),
              ),
              SizedBox(width: MyResponsive.width(value: 4)),
              Text(
                'Here is some information about the place',
                style: AppTextStyles.medium12.copyWith(
                  color: AppColors.black.withValues(alpha: .5),
                ),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Container(
            width: double.infinity,
            height: MyResponsive.height(value: 200),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(MyResponsive.radius(value: 4)),
            ),
            child: Image.asset(
              AppAssets.test,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}

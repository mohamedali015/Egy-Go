import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class GovernoratesCategoryGridViewItem extends StatelessWidget {
  const GovernoratesCategoryGridViewItem({
    super.key,
    required this.title,
    required this.name,
    required this.icon,
  });

  final String title;
  final String name;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: MyResponsive.paddingAll(value: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .9),
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
          border: Border.all(color: AppColors.grey, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgWrapper(
              path: icon,
              width: MyResponsive.width(value: 50),
              color: AppColors.black,
            ),
            SizedBox(
              height: MyResponsive.height(value: 8),
            ),
            Text(
              name,
              style: AppTextStyles.bold18.copyWith(color: AppColors.black),
            ),
            SizedBox(
              height: MyResponsive.height(value: 4),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.medium16.copyWith(color: AppColors.black),
            )
          ],
        ));
  }
}

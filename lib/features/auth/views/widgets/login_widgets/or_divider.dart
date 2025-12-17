import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: AppColors.grey,
          ),
        ),
        Padding(
          padding: MyResponsive.paddingSymmetric(horizontal: 18),
          child: Text(
            AppStrings.or,
            style: AppTextStyles.bold13,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: MyResponsive.height(value: 1),
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}

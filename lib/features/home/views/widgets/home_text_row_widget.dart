import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';

class HomeTextRowWidget extends StatelessWidget {
  const HomeTextRowWidget(
      {super.key, required this.title, required this.destinationPath});

  final String title;
  final String destinationPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bold18,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, destinationPath);
          },
          child: Text(
            AppStrings.seeAll,
            style: AppTextStyles.semiBold12.copyWith(color: AppColors.primary),
          ),
        )
      ],
    );
  }
}

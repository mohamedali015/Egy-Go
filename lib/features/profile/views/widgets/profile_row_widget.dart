import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/my_responsive.dart';

class ProfileRowWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  final Widget goTo;

  const ProfileRowWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.goTo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => MyNavigator.goTo(screen: goTo),
      child: Row(
        children: [
          SvgWrapper(
            path: imagePath,
            width: MyResponsive.width(value: 20),
          ),
          SizedBox(width: MyResponsive.width(value: 20)),
          Text(
            title,
            style: AppTextStyles.medium18,
          ),
          const Spacer(),
          SvgWrapper(
            path: AppAssets.forwardArrow,
          ),
        ],
      ),
    );
  }
}

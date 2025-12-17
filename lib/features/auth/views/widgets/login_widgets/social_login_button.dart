import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/shared_widgets/svg_wrapper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.imagePath,
    required this.title,
    this.onPressed,
  });

  final String imagePath;
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(
          double.infinity,
          MyResponsive.height(value: 40),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
        ),
      ),
      child: ListTile(
        leading: SvgWrapper(path: imagePath),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.bold16,
        ),
      ),
    );
  }
}

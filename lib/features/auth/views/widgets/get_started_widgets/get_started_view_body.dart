import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:egy_go/features/auth/views/register_view.dart';
import 'package:flutter/material.dart';

class GetStartedViewBody extends StatelessWidget {
  const GetStartedViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppAssets.getStartedImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withAlpha(200),
              ],
              stops: [0.2, 1.0],
            ),
          ),
        ),
        Padding(
          padding: MyResponsive.paddingSymmetric(
            horizontal: 30,
          ),
          child: Column(
            children: [
              Spacer(),
              Text(
                AppStrings.getStartedTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.semiBold34.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                height: MyResponsive.height(value: 16),
              ),
              Text(
                AppStrings.getStartedSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular14.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                height: MyResponsive.height(value: 20),
              ),
              CustomButton(
                title: AppStrings.login,
                onPressed: () {
                  Navigator.pushNamed(context, LoginView.routeName);
                },
              ),
              SizedBox(
                height: MyResponsive.height(value: 12),
              ),
              CustomButton(
                title: AppStrings.register,
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                onPressed: () {
                  Navigator.pushNamed(context, RegisterView.routeName);
                },
              ),
              SizedBox(
                height: MyResponsive.height(value: 50),
              )
            ],
          ),
        )
      ],
    );
  }
}

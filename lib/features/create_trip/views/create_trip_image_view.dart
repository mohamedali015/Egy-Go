import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/create_trip/views/create_trip_form_view.dart';
import 'package:flutter/material.dart';

class CreateTripImageView extends StatelessWidget {
  const CreateTripImageView({super.key});

  static const String routeName = "create_trip_image";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildWidget(context),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppAssets.createTrip,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MyResponsive.height(value: 55),
            ),
            Text(
              AppStrings.startYourTrip,
              style: AppTextStyles.bold20.copyWith(
                color: AppColors.white,
              ),
            ),
            Spacer(),
            Padding(
              padding: MyResponsive.paddingSymmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.tripImageTitle,
                      style: AppTextStyles.semiBold34.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyResponsive.height(value: 12),
            ),
            Text(
              AppStrings.tripImageSubtitle,
              style: AppTextStyles.semiBold12.copyWith(
                color: AppColors.white,
              ),
            ),
            SizedBox(
              height: MyResponsive.height(value: 60),
            ),
            Padding(
              padding: MyResponsive.paddingSymmetric(horizontal: 16),
              child: CustomButton(
                title: AppStrings.startNow,
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.black,
                onPressed: () {
                  // MyNavigator.goTo(screen: CreateTripFormView());
                  Navigator.pushNamed(context, CreateTripFormView.routeName);
                },
              ),
            ),
            SizedBox(
              height: MyResponsive.height(value: 50),
            ),
          ],
        )
      ],
    );
  }
}

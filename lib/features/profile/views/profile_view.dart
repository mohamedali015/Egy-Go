import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:egy_go/core/user/manager/user_cubit/user_cubit.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/profile/views/favorite_view.dart';
import 'package:egy_go/features/profile/views/my_profile_view.dart';
import 'package:egy_go/features/trip/views/trips_screen.dart';
import 'package:flutter/material.dart';

import 'widgets/profile_row_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        centerTitle: true,
      ),
      body: Padding(
        padding: MyResponsive.paddingSymmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: MyResponsive.height(value: 40),
            ),
            ClipOval(
              child: Image.asset(
                AppAssets.profileImage,
                width: MyResponsive.width(value: 150),
                height: MyResponsive.width(value: 150),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: MyResponsive.height(value: 20),
            ),
            Text(
              UserCubit.get(context).userModel.name ?? 'User Name',
              style: AppTextStyles.semiBold18.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: MyResponsive.height(value: 100)),
            ProfileRowWidget(
              title: AppStrings.myProfile,
              imagePath: AppAssets.profilePerson,
              goTo: MyProfileView(),
            ),
            SizedBox(height: MyResponsive.height(value: 38)),
            ProfileRowWidget(
              title: AppStrings.myTrips,
              imagePath: AppAssets.trips,
              goTo: TripsScreen(),
            ),
            SizedBox(height: MyResponsive.height(value: 38)),
            ProfileRowWidget(
              title: AppStrings.myFavorites,
              imagePath: AppAssets.profileFavorite,
              goTo: FavoriteView(),
            ),
            SizedBox(height: MyResponsive.height(value: 38)),
            Divider(
              color: AppColors.primary,
              thickness: 1,
            ),
            SizedBox(height: MyResponsive.height(value: 42)),
            InkWell(
              onTap: UserCubit.get(context).logout,
              child: Row(
                children: [
                  SvgWrapper(path: AppAssets.profileLogout),
                  SizedBox(width: MyResponsive.width(value: 20)),
                  Text(
                    AppStrings.logout,
                    style: AppTextStyles.medium18,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

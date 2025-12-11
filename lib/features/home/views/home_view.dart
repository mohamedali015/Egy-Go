import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/home/views/widgets/home_banner.dart';
import 'package:egy_go/features/places/views/places_view.dart';
import 'package:egy_go/features/governorates/views/governorates_view.dart';
import 'package:flutter/material.dart';

import 'widgets/home_text_row_widget.dart';
import 'widgets/recommended_list_view.dart';
import 'widgets/special_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeBanner(),
          Padding(
            padding: MyResponsive.paddingSymmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MyResponsive.height(value: 22),
                ),
                HomeTextRowWidget(
                  title: AppStrings.specialForYou,
                  destinationPath: GovernoratesView.routeName,
                ),
                SizedBox(
                  height: MyResponsive.height(value: 16),
                ),
                SpecialListView(),
                SizedBox(
                  height: MyResponsive.height(value: 22),
                ),
                Text(
                  AppStrings.recommended,
                  style: AppTextStyles.bold18,
                ),
                SizedBox(
                  height: MyResponsive.height(value: 16),
                ),
                RecommendedListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

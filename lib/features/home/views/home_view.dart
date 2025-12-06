import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/home/views/recommended_discover_more_view.dart';
import 'package:egy_go/features/home/views/special_discover_more_view.dart';
import 'package:egy_go/features/home/views/widgets/home_view_widgets/home_text_row_widget.dart';
import 'package:flutter/material.dart';

import 'widgets/home_view_widgets/recommended_list_view.dart';
import 'widgets/home_view_widgets/special_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeTextRowWidget(
              title: AppStrings.specialForYou,
              destinationPath: SpecialDiscoverMoreView.routeName,
            ),
            SizedBox(
              height: MyResponsive.height(value: 16),
            ),
            SpecialListView(),
            SizedBox(
              height: MyResponsive.height(value: 22),
            ),
            HomeTextRowWidget(
              title: AppStrings.recommended,
              destinationPath: RecommendedDiscoverMoreView.routeName,
            ),
            SizedBox(
              height: MyResponsive.height(value: 16),
            ),
            RecommendedListView(),
          ],
        ),
      ),
    );
  }
}

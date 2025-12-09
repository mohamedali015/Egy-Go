import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/home/views/home_view.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';

class AppHomeView extends StatelessWidget {
  const AppHomeView({super.key});

  static const String routeName = 'app_bottom_navigation_bar';
  final int currentIndex = 0;

  final List<Widget> screens = const [
    HomeView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: [
          BottomNavigationBarItem(
            icon: SvgWrapper(
              path: AppAssets.home,
              width: MyResponsive.width(value: 25),
              color: currentIndex == 0 ? AppColors.primary : AppColors.black,
            ),
            label: AppStrings.profile,
          ),
          BottomNavigationBarItem(
            icon: SvgWrapper(
              path: AppAssets.trips,
              width: MyResponsive.width(value: 25),
              height: MyResponsive.height(value: 25),
              color: currentIndex == 1 ? AppColors.primary : AppColors.black,
            ),
            label: AppStrings.trips,
          ),
          BottomNavigationBarItem(
            icon: SvgWrapper(
              path: AppAssets.profile,
              width: MyResponsive.width(value: 25),
              color: currentIndex == 2 ? AppColors.primary : AppColors.black,
            ),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

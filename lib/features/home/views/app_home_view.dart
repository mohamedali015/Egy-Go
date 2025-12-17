import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/svg_wrapper.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/create_trip/views/create_trip_image_view.dart';
import 'package:egy_go/features/home/views/home_view.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';

class AppHomeView extends StatefulWidget {
  const AppHomeView({super.key});
  static const String routeName = 'app_bottom_navigation_bar';

  @override
  State<AppHomeView> createState() => _AppHomeViewState();
}

class _AppHomeViewState extends State<AppHomeView> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeView(),
    Placeholder(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      floatingActionButton: SizedBox(
        height: MyResponsive.height(value: 65),
        width: MyResponsive.width(value: 65),
        child: FloatingActionButton(
          onPressed: () {
            MyNavigator.goTo(screen: CreateTripImageView());
          },
          backgroundColor: AppColors.primary,
          child: SvgWrapper(
            path: AppAssets.startTrip,
            width: MyResponsive.fontSize(value: 35),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgWrapper(
              path: AppAssets.home,
              width: MyResponsive.width(value: 25),
              color: currentIndex == 0 ? AppColors.primary : AppColors.black,
            ),
            label: AppStrings.home,
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

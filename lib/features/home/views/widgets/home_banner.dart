import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/home_search/view/home_search_view.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: MyResponsive.paddingSymmetric(
        horizontal: 10,
        vertical: 12,
      ),
      height: MyResponsive.height(value: 280),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBanner),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          // here i will put image of user in clipped circle
          Row(),
          Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, HomeSearchView.routeName);
            },
            child: Padding(
              padding: MyResponsive.paddingSymmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                padding: MyResponsive.paddingSymmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .3),
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 50)),
                  border: Border.all(color: AppColors.white, width: .7),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.black.withValues(alpha: .5),
                      size: MyResponsive.fontSize(value: 25),
                    ),
                    SizedBox(width: MyResponsive.width(value: 10)),
                    Text(
                      AppStrings.searchHint,
                      style: AppTextStyles.regular14.copyWith(
                        color: AppColors.black.withValues(alpha: .5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

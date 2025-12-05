import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/home/views/widgets/home_text_row_widget.dart';
import 'package:flutter/material.dart';

import 'widgets/special_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: MyResponsive.height(value: 8),
          ),
          HomeTextRowWidget(
            title: AppStrings.specialForYou,
          ),
          SizedBox(
            height: MyResponsive.height(value: 16),
          ),
          SpecialListView(),
        ],
      ),
    );
  }
}

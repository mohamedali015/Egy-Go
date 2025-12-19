import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class TripsViewBody extends StatelessWidget {
  const TripsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: MyResponsive.height(value: 30),
          ),
          // Text(
          //   AppStrings.myTrips,
          //   style: AppTextStyles.semiBold20,
          // ),
        ],
      ),
    );
  }
}

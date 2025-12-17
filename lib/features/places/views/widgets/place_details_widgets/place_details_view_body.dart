import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/guides/views/guides_view.dart';
import 'package:flutter/material.dart';
import 'first_section_details.dart';
import 'place_details_stack_slider_widget.dart';
import 'second_section_features.dart';
import 'third_section_location.dart';

class PlaceDetailsViewBody extends StatelessWidget {
  const PlaceDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaceDetailsStackSliderWidget(),
          SizedBox(height: MyResponsive.height(value: 20)),
          FirstSectionDetails(),
          SizedBox(
            height: MyResponsive.height(value: 40),
          ),
          SecondSectionFeatures(),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          ThirdSectionLocation(),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          // ForthSectionReviews(),

          Padding(
            padding: MyResponsive.paddingSymmetric(horizontal: 20),
            child: CustomButton(
              title: AppStrings.findGuide,
              onPressed: () {
                MyNavigator.goTo(screen: GuidesView());
              },
            ),
          ),
          SizedBox(
            height: MyResponsive.height(value: 40),
          ),
        ],
      ),
    );
  }
}

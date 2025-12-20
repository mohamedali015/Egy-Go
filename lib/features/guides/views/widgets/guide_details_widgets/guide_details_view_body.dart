import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/views/widgets/guide_details_widgets/guide_details_header.dart';
import 'package:egy_go/features/guides/views/widgets/guide_details_widgets/guide_info_section.dart';
import 'package:flutter/material.dart';

class GuideDetailsViewBody extends StatelessWidget {
  const GuideDetailsViewBody({super.key, required this.guide});

  final Guide guide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: MyResponsive.paddingSymmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MyResponsive.height(value: 16)),
                GuideDetailsHeader(guide: guide),
                SizedBox(height: MyResponsive.height(value: 24)),
                GuideInfoSection(guide: guide),
                SizedBox(height: MyResponsive.height(value: 24)),
              ],
            ),
          ),
        ),
        SizedBox(height: MyResponsive.height(value: 20)),
        Padding(
          padding: MyResponsive.paddingSymmetric(horizontal: 20),
          child: CustomButton(
            title: 'Select this Guide',
            onPressed: () {
              // TODO: Implement guide selection logic
            },
          ),
        ),
        SizedBox(height: MyResponsive.height(value: 25)),
      ],
    );
  }
}

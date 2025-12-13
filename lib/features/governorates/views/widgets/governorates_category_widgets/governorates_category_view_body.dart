import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';
import 'package:egy_go/features/governorates/views/widgets/governorates_category_widgets/governorates_category_grid_view.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_assets.dart';

class GovernoratesCategoryViewBody extends StatelessWidget {
  const GovernoratesCategoryViewBody({super.key, required this.governorate});

  final Governorate governorate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned.fill(
        //   child: Image.asset(
        //     AppAssets.test,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // Positioned.fill(
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         colors: [
        //           Colors.transparent,
        //           Colors.black.withValues(alpha: .2),
        //         ],
        //         stops: [0.0, 0.0],
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: MyResponsive.paddingSymmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MyResponsive.height(value: 100),
              ),

              // SizedBox(
              //   height: MyResponsive.height(value: 150),
              // ),
              Expanded(
                child: GovernoratesCategoryGridView(),
              ),
            ],
          ),
        )
      ],
    );
  }
}

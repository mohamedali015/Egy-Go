import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/cached_network_image_wrapper.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:egy_go/features/governorates/views/widgets/governorates_category_widgets/governorates_category_grid_view.dart';
import 'package:flutter/material.dart';

class GovernoratesCategoryViewBody extends StatelessWidget {
  const GovernoratesCategoryViewBody({super.key});

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MyResponsive.height(value: 300),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(MyResponsive.width(value: 16)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImageWrapper(
                      imagePath: GovernoratesCubit.get(context)
                          .selectedGovernorate!
                          .coverImage!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: .4),
                          ],
                          stops: [0.0, 0.0],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MyResponsive.height(value: 40),
                      ),
                      Text(
                        GovernoratesCubit.get(context)
                            .selectedGovernorate!
                            .name!,
                        style: AppTextStyles.bold36
                            .copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyResponsive.height(value: 60),
            ),
            Expanded(
              child: Padding(
                padding: MyResponsive.paddingSymmetric(horizontal: 16),
                child: GovernoratesCategoryGridView(),
              ),
            ),
          ],
        )
      ],
    );
  }
}

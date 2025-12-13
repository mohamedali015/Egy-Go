import 'package:egy_go/core/shared_widgets/cached_network_image_wrapper.dart';
import 'package:egy_go/features/governorates/data/models/governorates_response_model.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:flutter/material.dart';
import '../../../../core/helper/my_responsive.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../governorates/views/governorates_category_view.dart';

class GovernorateItem extends StatelessWidget {
  const GovernorateItem(
      {super.key, required this.governorate, required this.index});

  final Governorate governorate;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GovernoratesCubit.get(context).selectedGovernorate = index;
        Navigator.pushNamed(
          context,
          GovernoratesCategoryView.routeName,
          arguments: governorate,
        );
      },
      child: Container(
        width: MyResponsive.width(value: 200),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            MyResponsive.radius(value: 10),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: governorate.coverImage != null
                  ? CachedNetworkImageWrapper(
                      imagePath: governorate.coverImage!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      AppAssets.test,
                      fit: BoxFit.cover,
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
                      Colors.black.withAlpha(90),
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
                ),

                Text(
                  governorate.name!,
                  style: AppTextStyles.bold20.copyWith(color: AppColors.white),
                ),
                // SizedBox(
                //   height: MyResponsive.height(value: 8),
                // ),
                // Row(
                //   children: [
                //     RatingBarWrapper(
                //       rating: 4,
                //       starSize: 17,
                //       spaceBetweenStars: .75,
                //     ),
                //     SizedBox(
                //       width: MyResponsive.width(value: 6),
                //     ),
                //     Text(
                //       "(${10})",
                //       style: AppTextStyles.semiBold12.copyWith(
                //         color: Colors.deepOrange,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

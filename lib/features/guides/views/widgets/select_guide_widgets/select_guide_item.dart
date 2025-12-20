import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/cached_network_image_wrapper.dart';
import 'package:egy_go/core/shared_widgets/rating_bar_wrapper.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/views/guide_details_screen.dart';
import 'package:flutter/material.dart';

class SelectGuideItem extends StatelessWidget {
  const SelectGuideItem({super.key, required this.guide, required this.tripId});

  final Guide guide;
  final String tripId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GuideDetailsScreen(guide: guide, tripId: tripId),
          ),
        );
      },
      child: Container(
        padding: MyResponsive.paddingSymmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
          border: Border.all(
            color: AppColors.black.withValues(alpha: .1),
          ),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(MyResponsive.radius(value: 12)),
              child: CachedNetworkImageWrapper(
                imagePath: guide.photo!.url ?? '',
                width: MyResponsive.width(value: 90),
                height: MyResponsive.width(value: 90),
              ),
            ),

            SizedBox(width: MyResponsive.width(value: 18)),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME + RATING
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          guide.name ?? 'Unknown',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bold16,
                        ),
                      ),
                      Row(
                        children: [
                          RatingBarWrapper(
                            rating: guide.rating ?? 0,
                            starSize: 13,
                            spaceBetweenStars: 1,
                          ),
                          SizedBox(width: MyResponsive.width(value: 6)),
                          Text(
                            "(${guide.rating?.toStringAsFixed(1) ?? '0.0'})",
                            style: AppTextStyles.semiBold14.copyWith(
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: MyResponsive.height(value: 4)),

                  /// DESCRIPTION
                  Text(
                    guide.bio ?? 'No description available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.medium12.copyWith(
                      color: AppColors.black.withValues(alpha: .6),
                    ),
                  ),

                  SizedBox(height: MyResponsive.height(value: 10)),

                  /// PRICE + LOCATION
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: MyResponsive.fontSize(value: 16),
                        color: Colors.green,
                      ),
                      SizedBox(width: MyResponsive.width(value: 4)),
                      Text(
                        "${guide.pricePerHour ?? 0}/hour",
                        style: AppTextStyles.medium12,
                      ),
                      SizedBox(width: MyResponsive.width(value: 12)),
                      Icon(
                        Icons.location_on,
                        size: MyResponsive.fontSize(value: 16),
                        color: Colors.grey,
                      ),
                      SizedBox(width: MyResponsive.width(value: 4)),
                      Expanded(
                        child: Text(
                          guide.provinces?.isNotEmpty == true
                              ? guide.provinces!.first.name ?? 'Unknown'
                              : 'Unknown',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.medium12,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: MyResponsive.height(value: 8)),

                  /// LANGUAGES
                  Row(
                    children: [
                      Icon(
                        Icons.translate,
                        size: MyResponsive.fontSize(value: 16),
                        color: Colors.grey,
                      ),
                      SizedBox(width: MyResponsive.width(value: 4)),
                      Expanded(
                        child: Text(
                          guide.languages?.join(', ') ?? 'N/A',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.medium12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

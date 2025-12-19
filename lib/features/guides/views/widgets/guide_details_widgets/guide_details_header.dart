import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/cached_network_image_wrapper.dart';
import 'package:egy_go/core/shared_widgets/rating_bar_wrapper.dart';
import 'package:egy_go/core/utils/app_assets.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:flutter/material.dart';

class GuideDetailsHeader extends StatelessWidget {
  const GuideDetailsHeader({super.key, required this.guide});

  final Guide guide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// GUIDE IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 16)),
          child: CachedNetworkImageWrapper(
            imagePath: guide.photo?.url ?? AppAssets.test,
            width: MyResponsive.width(value: 250),
            height: MyResponsive.height(value: 250),
          ),
        ),

        SizedBox(height: MyResponsive.height(value: 16)),

        /// NAME
        Text(
          guide.name ?? 'Unknown',
          style: AppTextStyles.bold20,
          textAlign: TextAlign.center,
        ),

        SizedBox(height: MyResponsive.height(value: 8)),

        /// RATING
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBarWrapper(
              rating: 5,
              starSize: 16,
              spaceBetweenStars: 2,
            ),
            SizedBox(width: MyResponsive.width(value: 4)),
            Text(
              "${guide.rating?.toStringAsFixed(1) ?? '0.0'} (${guide.ratingCount ?? 0} reviews)",
              style: AppTextStyles.medium14.copyWith(
                color: AppColors.black.withValues(alpha: .6),
              ),
            ),
          ],
        ),

        SizedBox(height: MyResponsive.height(value: 8)),

        /// BADGES
        Wrap(
          spacing: MyResponsive.width(value: 8),
          runSpacing: MyResponsive.height(value: 8),
          alignment: WrapAlignment.center,
          children: [
            if (guide.isVerified == true)
              _Badge(
                icon: Icons.verified,
                label: 'Verified',
                color: Colors.blue,
              ),
            if (guide.isLicensed == true)
              _Badge(
                icon: Icons.card_membership,
                label: 'Licensed',
                color: Colors.green,
              ),
            if (guide.canEnterArchaeologicalSites == true)
              _Badge(
                icon: Icons.museum,
                label: 'Archaeological Sites Access',
                color: Colors.orange,
              ),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MyResponsive.paddingSymmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: MyResponsive.fontSize(value: 14),
            color: color,
          ),
          SizedBox(width: MyResponsive.width(value: 4)),
          Text(
            label,
            style: AppTextStyles.medium12.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

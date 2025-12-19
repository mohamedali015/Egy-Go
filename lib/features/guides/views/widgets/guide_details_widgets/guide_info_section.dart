import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:flutter/material.dart';

class GuideInfoSection extends StatelessWidget {
  const GuideInfoSection({super.key, required this.guide});

  final Guide guide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// BIO
        if (guide.bio != null && guide.bio!.isNotEmpty) ...[
          Text(
            'About',
            style: AppTextStyles.bold16,
          ),
          SizedBox(height: MyResponsive.height(value: 8)),
          Text(
            guide.bio!,
            style: AppTextStyles.medium14.copyWith(
              color: AppColors.black.withValues(alpha: .7),
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 20)),
        ],

        /// PRICE
        _InfoRow(
          icon: Icons.attach_money,
          iconColor: Colors.green,
          title: 'Price',
          value: '\$${guide.pricePerHour ?? 0} per hour',
        ),

        SizedBox(height: MyResponsive.height(value: 12)),

        /// LANGUAGES
        _InfoRow(
          icon: Icons.translate,
          iconColor: Colors.blue,
          title: 'Languages',
          value: guide.languages?.join(', ') ?? 'N/A',
        ),

        SizedBox(height: MyResponsive.height(value: 12)),

        /// TOTAL TRIPS
        _InfoRow(
          icon: Icons.route,
          iconColor: Colors.orange,
          title: 'Total Trips',
          value: '${guide.totalTrips ?? 0} trips completed',
        ),

        SizedBox(height: MyResponsive.height(value: 12)),

        /// PROVINCES
        if (guide.provinces != null && guide.provinces!.isNotEmpty) ...[
          _InfoRow(
            icon: Icons.location_on,
            iconColor: Colors.red,
            title: 'Operates in',
            value: guide.provinces!.map((p) => p.name ?? '').join(', '),
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
        ],

        /// EMAIL
        if (guide.user?.email != null) ...[
          _InfoRow(
            icon: Icons.email,
            iconColor: Colors.purple,
            title: 'Contact Email',
            value: guide.user!.email!,
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: .02),
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
        border: Border.all(
          color: AppColors.black.withValues(alpha: .05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: MyResponsive.paddingAll(value: 8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .1),
              borderRadius:
                  BorderRadius.circular(MyResponsive.radius(value: 8)),
            ),
            child: Icon(
              icon,
              size: MyResponsive.fontSize(value: 20),
              color: iconColor,
            ),
          ),
          SizedBox(width: MyResponsive.width(value: 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.medium12.copyWith(
                    color: AppColors.black.withValues(alpha: .6),
                  ),
                ),
                SizedBox(height: MyResponsive.height(value: 2)),
                Text(
                  value,
                  style: AppTextStyles.semiBold14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

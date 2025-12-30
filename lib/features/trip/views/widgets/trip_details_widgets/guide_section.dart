import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/cached_network_image_wrapper.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart'
    as guides_model;
import 'package:egy_go/features/guides/views/guide_details_screen.dart';
import 'package:egy_go/features/guides/views/guide_filter_screen.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideSection extends StatelessWidget {
  const GuideSection({super.key, required this.trip});

  final TripModel trip;

  bool get isCancelled => trip.status?.toLowerCase() == 'cancelled';

  bool get hasGuide => trip.guide != null || trip.selectedGuide != null;

  TripGuide? get guide => trip.selectedGuide ?? trip.guide;

  guides_model.Guide _convertTripGuideToGuide(TripGuide tripGuide) {
    return guides_model.Guide(
      sId: tripGuide.sId,
      name: tripGuide.name,
      slug: tripGuide.slug,
      isVerified: tripGuide.isVerified,
      isActive: tripGuide.isActive,
      canEnterArchaeologicalSites: tripGuide.canEnterArchaeologicalSites,
      isLicensed: tripGuide.isLicensed,
      languages: tripGuide.languages,
      pricePerHour: tripGuide.pricePerHour,
      bio: tripGuide.bio,
      rating: tripGuide.rating,
      ratingCount: tripGuide.ratingCount,
      totalTrips: tripGuide.totalTrips,
      photo: tripGuide.photo != null
          ? guides_model.Photo(
              url: tripGuide.photo!.url,
              publicId: tripGuide.photo!.publicId,
            )
          : null,
      location: tripGuide.location != null
          ? guides_model.GuideLocation(
              type: tripGuide.location!.type,
              coordinates: tripGuide.location!.coordinates,
            )
          : null,
      user: tripGuide.user != null
          ? guides_model.GuideUser(
              sId: tripGuide.user!.sId,
              email: tripGuide.user!.email,
              name: tripGuide.user!.name,
            )
          : null,
      createdAt: tripGuide.createdAt,
      updatedAt: tripGuide.updatedAt,
    );
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If trip is cancelled, don't show any guide section
    if (isCancelled) {
      return SizedBox.shrink();
    }

    // If no guide selected, show "Select Guide" button
    if (!hasGuide) {
      return Container(
        padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_search,
              size: MyResponsive.fontSize(value: 48),
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
            SizedBox(height: MyResponsive.height(value: 12)),
            Text(
              'No Guide Selected',
              style: AppTextStyles.bold16,
            ),
            SizedBox(height: MyResponsive.height(value: 8)),
            Text(
              'Select a guide for your trip',
              style: AppTextStyles.medium14.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MyResponsive.height(value: 16)),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GuideFilterScreen(tripId: trip.sId ?? ''),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.scaffoldBackground,
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                minimumSize:
                    Size(double.infinity, MyResponsive.height(value: 50)),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 8)),
                ),
              ),
              child: Text(
                'Select Guide',
                style: AppTextStyles.semiBold16.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // If guide is selected, show guide information (tappable for details)
    final selectedGuide = guide!;

    return Container(
      padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Guide',
            style: AppTextStyles.bold18,
          ),
          SizedBox(height: MyResponsive.height(value: 16)),
          GestureDetector(
            onTap: () {
              // Navigate to guide details in read-only mode
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuideDetailsScreen(
                    guide: _convertTripGuideToGuide(selectedGuide),
                    tripId: null, // Pass null to make it read-only
                  ),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 12)),
                  child: CachedNetworkImageWrapper(
                    imagePath: selectedGuide.photo?.url ?? '',
                    width: MyResponsive.width(value: 80),
                    height: MyResponsive.width(value: 80),
                  ),
                ),
                SizedBox(width: MyResponsive.width(value: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedGuide.name ?? 'Unknown Guide',
                        style: AppTextStyles.bold16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: MyResponsive.height(value: 6)),
                      if (selectedGuide.languages != null &&
                          selectedGuide.languages!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.translate,
                              size: MyResponsive.fontSize(value: 14),
                              color: AppColors.grey,
                            ),
                            SizedBox(width: MyResponsive.width(value: 4)),
                            Expanded(
                              child: Text(
                                selectedGuide.languages!.join(', '),
                                style: AppTextStyles.medium12.copyWith(
                                  color: AppColors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: MyResponsive.height(value: 6)),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: MyResponsive.fontSize(value: 14),
                            color: Colors.orange,
                          ),
                          SizedBox(width: MyResponsive.width(value: 4)),
                          Text(
                            '${selectedGuide.rating?.toStringAsFixed(1) ?? '0.0'} (${selectedGuide.ratingCount ?? 0} reviews)',
                            style: AppTextStyles.medium12.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: MyResponsive.fontSize(value: 16),
                  color: AppColors.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 20)),
          Text(
            'Contact Guide',
            style: AppTextStyles.semiBold14.copyWith(
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: selectedGuide.user?.email != null
                      ? () => _launchEmail(selectedGuide.user!.email!)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: MyResponsive.paddingSymmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(MyResponsive.radius(value: 8)),
                    ),
                  ),
                  icon:
                      Icon(Icons.email, size: MyResponsive.fontSize(value: 18)),
                  label: Text(
                    'Email',
                    style: AppTextStyles.medium14,
                  ),
                ),
              ),
              SizedBox(width: MyResponsive.width(value: 12)),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: trip.tourist?.phone != null
                      ? () => _launchPhone(trip.tourist!.phone!)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: MyResponsive.paddingSymmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(MyResponsive.radius(value: 8)),
                    ),
                  ),
                  icon:
                      Icon(Icons.phone, size: MyResponsive.fontSize(value: 18)),
                  label: Text(
                    'Call',
                    style: AppTextStyles.medium14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

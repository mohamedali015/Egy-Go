import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/views/trip_chat_screen.dart';
import 'package:flutter/material.dart';

class ChatSection extends StatelessWidget {
  const ChatSection({super.key, required this.trip});

  final TripModel trip;

  /// Check if chat should be visible
  /// Show chat button if trip has a selected guide and is NOT cancelled or rejected
  bool get shouldShowChat {
    final status = trip.status?.toLowerCase();
    final hasSelectedGuide = trip.selectedGuide != null;

    // Don't show chat if cancelled or rejected
    if (status == 'cancelled' || status == 'rejected') {
      return false;
    }

    // Only show chat if there's a selected guide
    return hasSelectedGuide;
  }

  @override
  Widget build(BuildContext context) {
    if (!shouldShowChat) {
      return SizedBox.shrink();
    }

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
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: AppColors.primary,
                size: MyResponsive.fontSize(value: 24),
              ),
              SizedBox(width: MyResponsive.width(value: 8)),
              Text(
                'Communication',
                style: AppTextStyles.bold18,
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Text(
            'Chat with your guide to coordinate trip details',
            style: AppTextStyles.regular14.copyWith(
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 16)),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                TripChatScreen.routeName,
                arguments: {
                  'tripId': trip.sId,
                  'guide': trip.selectedGuide,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize:
                  Size(double.infinity, MyResponsive.height(value: 50)),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MyResponsive.radius(value: 8)),
              ),
            ),
            icon: Icon(Icons.chat, size: MyResponsive.fontSize(value: 20)),
            label: Text(
              'Chat with Guide',
              style: AppTextStyles.semiBold16,
            ),
          ),
        ],
      ),
    );
  }
}

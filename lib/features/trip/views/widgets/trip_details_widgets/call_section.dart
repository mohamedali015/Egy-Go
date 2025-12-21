import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_cubit.dart';
import 'package:flutter/material.dart';

class CallSection extends StatelessWidget {
  const CallSection({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    // Only show call section if guide is selected and trip is in pending status
    if (trip.selectedGuide == null ||
        trip.status == 'cancelled' ||
        trip.status == 'completed') {
      return SizedBox.shrink();
    }

    return Container(
      padding: MyResponsive.paddingAll(value: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Call Guide',
            style: AppTextStyles.semiBold18,
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Text(
            'Start a video call with your guide to discuss the itinerary and finalize details.',
            style: AppTextStyles.regular14.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 16)),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                if (trip.selectedGuide?.sId != null) {
                  TripDetailsCubit.get(context).initiateCall(
                    trip.sId!,
                    trip.selectedGuide!.sId!,
                  );
                }
              },
              icon: Icon(Icons.video_call, color: Colors.white),
              label: Text(
                'Start Video Call',
                style: AppTextStyles.semiBold16.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

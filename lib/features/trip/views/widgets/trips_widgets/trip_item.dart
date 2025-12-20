import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/views/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripItem extends StatelessWidget {
  const TripItem({super.key, required this.trip});

  final TripModel trip;

  String _getProvinceName(BuildContext context) {
    if (trip.provinceId == null) return 'Unknown Province';

    final governoratesCubit = GovernoratesCubit.get(context);
    final province = governoratesCubit.governorates.firstWhere(
      (gov) => gov.sId == trip.provinceId,
      orElse: () => governoratesCubit.governorates.first,
    );

    return province.name ?? 'Unknown Province';
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Date not set';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _getStatusText() {
    switch (trip.status?.toLowerCase()) {
      case 'selecting_guide':
        return 'Selecting Guide';
      case 'awaiting_call':
        return 'Awaiting Call';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return trip.status ?? 'Unknown';
    }
  }

  Color _getStatusColor() {
    switch (trip.status?.toLowerCase()) {
      case 'selecting_guide':
        return Colors.orange;
      case 'awaiting_call':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(tripId: trip.sId ?? ''),
          ),
        );
      },
      child: Container(
        padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
          border: Border.all(
            color: AppColors.black.withValues(alpha: .1),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Trip to ${_getProvinceName(context)}',
                    style: AppTextStyles.bold16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: MyResponsive.paddingSymmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(MyResponsive.radius(value: 12)),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: AppTextStyles.medium12.copyWith(
                      color: _getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MyResponsive.height(value: 8)),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: MyResponsive.fontSize(value: 14),
                  color: AppColors.grey,
                ),
                SizedBox(width: MyResponsive.width(value: 6)),
                Expanded(
                  child: Text(
                    _formatDate(trip.startAt),
                    style: AppTextStyles.medium12.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MyResponsive.height(value: 6)),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: MyResponsive.fontSize(value: 14),
                  color: AppColors.grey,
                ),
                SizedBox(width: MyResponsive.width(value: 6)),
                Expanded(
                  child: Text(
                    trip.meetingAddress ?? 'Address not set',
                    style: AppTextStyles.medium12.copyWith(
                      color: AppColors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (trip.totalDurationMinutes != null) ...[
              SizedBox(height: MyResponsive.height(value: 6)),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: MyResponsive.fontSize(value: 14),
                    color: AppColors.grey,
                  ),
                  SizedBox(width: MyResponsive.width(value: 6)),
                  Text(
                    '${trip.totalDurationMinutes! ~/ 60} hours ${trip.totalDurationMinutes! % 60} minutes',
                    style: AppTextStyles.medium12.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

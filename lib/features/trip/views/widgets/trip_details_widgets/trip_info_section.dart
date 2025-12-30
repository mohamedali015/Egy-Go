import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripInfoSection extends StatelessWidget {
  const TripInfoSection({super.key, required this.trip});

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
      return DateFormat('EEEE, MMM dd, yyyy at hh:mm a').format(date);
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
      case 'pending_confirmation':
        return 'Pending Confirmation';
      case 'confirmed':
        return 'Confirmed';
      case 'upcoming':
        return 'Upcoming Trip';
      case 'in_progress':
        return 'In Progress';
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
        return Colors.amber; // Warm amber for selection phase
      case 'awaiting_call':
        return Colors.blue.shade600; // Deep blue for awaiting action
      case 'pending_confirmation':
        return Colors.orange.shade700; // Rich orange for pending
      case 'confirmed':
        return Colors.teal; // Teal for confirmed (positive but not complete)
      case 'upcoming':
        return Colors.deepPurple; // Deep purple for upcoming urgency
      case 'in_progress':
        return Colors.indigo; // Indigo for active trip
      case 'completed':
        return Colors.green.shade600; // Strong green for success
      case 'cancelled':
        return Colors.red.shade700; // Deep red for cancelled
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Show upcoming banner if status is upcoming
          if (trip.status?.toLowerCase() == 'upcoming') ...[
            Container(
              padding:
                  MyResponsive.paddingSymmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade400, Colors.purple.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(MyResponsive.radius(value: 8)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_filled,
                    color: Colors.white,
                    size: MyResponsive.fontSize(value: 24),
                  ),
                  SizedBox(width: MyResponsive.width(value: 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Trip',
                          style: AppTextStyles.bold16.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: MyResponsive.height(value: 4)),
                        Text(
                          'Your trip starts within 24 hours',
                          style: AppTextStyles.regular12.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: MyResponsive.fontSize(value: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: MyResponsive.height(value: 16)),
          ],
          Text(
            'Trip Information',
            style: AppTextStyles.bold18,
          ),
          SizedBox(height: MyResponsive.height(value: 16)),
          _buildInfoRow(
            icon: Icons.location_city,
            label: 'Province',
            value: _getProvinceName(context),
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Date & Time',
            value: _formatDate(trip.startAt),
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Meeting Address',
            value: trip.meetingAddress ?? 'Not set',
          ),
          if (trip.totalDurationMinutes != null) ...[
            SizedBox(height: MyResponsive.height(value: 12)),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Duration',
              value:
                  '${trip.totalDurationMinutes! ~/ 60}h ${trip.totalDurationMinutes! % 60}m',
            ),
          ],
          SizedBox(height: MyResponsive.height(value: 12)),
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: _getStatusText(),
            valueColor: _getStatusColor(),
          ),
          if (trip.status?.toLowerCase() == 'cancelled') ...[
            if (trip.cancellationReason != null) ...[
              SizedBox(height: MyResponsive.height(value: 12)),
              _buildInfoRow(
                icon: Icons.cancel_outlined,
                label: 'Cancellation Reason',
                value: trip.cancellationReason!,
                valueColor: Colors.red,
              ),
            ],
            if (trip.cancelledAt != null) ...[
              SizedBox(height: MyResponsive.height(value: 12)),
              _buildInfoRow(
                icon: Icons.schedule,
                label: 'Cancelled At',
                value: _formatDate(trip.cancelledAt),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: MyResponsive.fontSize(value: 20),
          color: AppColors.primary,
        ),
        SizedBox(width: MyResponsive.width(value: 12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.medium12.copyWith(
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: MyResponsive.height(value: 4)),
              Text(
                value,
                style: AppTextStyles.semiBold14.copyWith(
                  color: valueColor ?? AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

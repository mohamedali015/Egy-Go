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
      case 'pending_confirmation':
        return Colors.orange;
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

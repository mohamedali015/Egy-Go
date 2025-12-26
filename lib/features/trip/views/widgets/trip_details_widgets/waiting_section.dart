import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:flutter/material.dart';

class WaitingSection extends StatelessWidget {
  const WaitingSection({super.key, required this.trip});

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

  String _getCallSummary() {
    // Get the last call session summary if exists
    if (trip.callSessions != null && trip.callSessions!.isNotEmpty) {
      final lastCallSession = trip.callSessions!.last;
      if (lastCallSession is Map && lastCallSession.containsKey('summary')) {
        return lastCallSession['summary'] ?? 'No summary provided';
      }
    }
    return 'No summary provided';
  }

  @override
  Widget build(BuildContext context) {
    // ONLY show when status is exactly 'pending_confirmation'
    // NOT for 'awaiting_payment' - that's handled by PaymentSection
    if (trip.status?.toLowerCase() != 'pending_confirmation') {
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
          // Header with icon
          Row(
            children: [
              Icon(
                Icons.hourglass_empty,
                color: Colors.orange,
                size: 24,
              ),
              SizedBox(width: MyResponsive.width(value: 8)),
              Expanded(
                child: Text(
                  'Awaiting Confirmation',
                  style: AppTextStyles.bold18.copyWith(color: Colors.orange),
                ),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 12)),

          // Description
          Text(
            'Your call has ended. The guide will review and confirm your trip details.',
            style: AppTextStyles.regular14.copyWith(color: Colors.grey[600]),
          ),

          SizedBox(height: MyResponsive.height(value: 20)),
          Divider(color: Colors.grey[300]),
          SizedBox(height: MyResponsive.height(value: 16)),

          // Call Summary from end call form
          Text(
            'Call Summary',
            style: AppTextStyles.semiBold16,
          ),
          SizedBox(height: MyResponsive.height(value: 8)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getCallSummary(),
              style: AppTextStyles.regular14.copyWith(color: Colors.grey[800]),
            ),
          ),

          SizedBox(height: MyResponsive.height(value: 16)),

          // Negotiated Price from end call form (if provided)
          if (trip.meta?.negotiatedPrice != null) ...[
            _buildInfoRow(
              icon: Icons.attach_money,
              label: 'Negotiated Price',
              value: '\$${trip.meta!.negotiatedPrice!.toStringAsFixed(2)}',
              valueColor: Colors.green,
              isBold: true,
            ),
            SizedBox(height: MyResponsive.height(value: 12)),
          ],

          // Province/Governorate
          _buildInfoRow(
            icon: Icons.location_city,
            label: 'Governorate',
            value: _getProvinceName(context),
          ),

          SizedBox(height: MyResponsive.height(value: 12)),

          // Meeting Address
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Meeting Address',
            value: trip.meetingAddress ?? 'Not specified',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.regular12.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: isBold
                    ? AppTextStyles.semiBold16
                        .copyWith(color: valueColor ?? Colors.black87)
                    : AppTextStyles.medium14
                        .copyWith(color: valueColor ?? Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// DONE: Waiting UI - Shows ONLY for pending_confirmation with call details

import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:flutter/material.dart';

class ProposalSection extends StatelessWidget {
  const ProposalSection({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    // Check if meta exists and has proposal info
    if (trip.meta == null || trip.meta!.proposalStatus == null) {
      return SizedBox.shrink();
    }

    final proposalStatus = trip.meta!.proposalStatus;
    final negotiatedPrice = trip.meta!.negotiatedPrice;

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
          Row(
            children: [
              Icon(
                proposalStatus == 'approved'
                    ? Icons.check_circle
                    : proposalStatus == 'rejected'
                        ? Icons.cancel
                        : Icons.pending,
                color: proposalStatus == 'approved'
                    ? Colors.green
                    : proposalStatus == 'rejected'
                        ? Colors.red
                        : Colors.orange,
              ),
              SizedBox(width: 8),
              Text(
                'Proposal ${proposalStatus?.toUpperCase() ?? 'PENDING'}',
                style: AppTextStyles.semiBold18.copyWith(
                  color: proposalStatus == 'approved'
                      ? Colors.green
                      : proposalStatus == 'rejected'
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ],
          ),
          if (negotiatedPrice != null) ...[
            SizedBox(height: MyResponsive.height(value: 12)),
            Text(
              'Negotiated Price: \$${negotiatedPrice.toStringAsFixed(2)}',
              style: AppTextStyles.semiBold16,
            ),
          ],
          if (proposalStatus == 'approved') ...[
            SizedBox(height: MyResponsive.height(value: 16)),
            _buildPaymentSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    // Check payment status
    final paymentStatus = trip.paymentStatus;

    if (paymentStatus == 'completed') {
      return Container(
        padding: MyResponsive.paddingAll(value: 12),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Payment Completed',
              style: AppTextStyles.semiBold14.copyWith(color: Colors.green),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(height: MyResponsive.height(value: 8)),
        Text(
          'Payment Required',
          style: AppTextStyles.semiBold16,
        ),
        SizedBox(height: MyResponsive.height(value: 12)),
        Text(
          'Please complete the payment to confirm your trip.',
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
              // TODO: Implement payment flow
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment feature coming soon'),
                ),
              );
            },
            icon: Icon(Icons.payment, color: Colors.white),
            label: Text(
              'Proceed to Payment',
              style: AppTextStyles.semiBold16.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

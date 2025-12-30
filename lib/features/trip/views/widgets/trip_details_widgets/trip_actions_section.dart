import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_cubit.dart';
import 'package:flutter/material.dart';

class TripActionsSection extends StatelessWidget {
  const TripActionsSection({super.key, required this.trip});

  final TripModel trip;

  bool get isCancelled => trip.status?.toLowerCase() == 'cancelled';

  bool get isCompleted => trip.status?.toLowerCase() == 'completed';

  bool get isInProgress => trip.status?.toLowerCase() == 'in_progress';

  void _showCancelDialog(BuildContext context) {
    final cubit = TripDetailsCubit.get(context);

    if (!cubit.canCancelTrip()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cubit.getCancellationMessage()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Cancel Trip',
            style: AppTextStyles.bold18,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to cancel this trip?',
                style: AppTextStyles.medium14,
              ),
              SizedBox(height: MyResponsive.height(value: 12)),
              Container(
                padding:
                    MyResponsive.paddingSymmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 8)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: MyResponsive.fontSize(value: 20),
                    ),
                    SizedBox(width: MyResponsive.width(value: 8)),
                    Expanded(
                      child: Text(
                        'Trips cannot be cancelled within 24 hours of the start time.',
                        style: AppTextStyles.medium12.copyWith(
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MyResponsive.height(value: 16)),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Cancellation Reason',
                  hintText: 'Enter reason for cancellation',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(MyResponsive.radius(value: 8)),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Keep Trip',
                style: AppTextStyles.semiBold14.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please provide a cancellation reason'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                cubit.cancelTrip(trip.sId ?? '', reasonController.text.trim());
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Cancel Trip',
                style: AppTextStyles.semiBold14.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Don't show any actions if trip is cancelled, completed, or in_progress
    if (isCancelled || isCompleted || isInProgress) {
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
          Text(
            'Trip Actions',
            style: AppTextStyles.bold18,
          ),
          SizedBox(height: MyResponsive.height(value: 16)),
          OutlinedButton.icon(
            onPressed: () => _showCancelDialog(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red),
              minimumSize:
                  Size(double.infinity, MyResponsive.height(value: 50)),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MyResponsive.radius(value: 8)),
              ),
            ),
            icon: Icon(Icons.cancel, size: MyResponsive.fontSize(value: 20)),
            label: Text(
              'Cancel Trip',
              style: AppTextStyles.semiBold16.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

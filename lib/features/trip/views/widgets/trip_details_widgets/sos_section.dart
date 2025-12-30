import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SosSection extends StatelessWidget {
  const SosSection({super.key, required this.trip});

  final TripModel trip;

  bool get isInProgress => trip.status?.toLowerCase() == 'in_progress';

  Future<void> _makeEmergencyCall(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '112');

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unable to make emergency call'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Unable to make emergency call'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEmergencyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: MyResponsive.fontSize(value: 28),
              ),
              SizedBox(width: MyResponsive.width(value: 8)),
              Text(
                'Emergency Call',
                style: AppTextStyles.bold18.copyWith(color: Colors.red),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are about to call emergency services (112).',
                style: AppTextStyles.medium16,
              ),
              SizedBox(height: MyResponsive.height(value: 12)),
              Container(
                padding:
                    MyResponsive.paddingSymmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(MyResponsive.radius(value: 8)),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Only use this for real emergencies.',
                  style: AppTextStyles.medium14.copyWith(
                    color: Colors.red[800],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: AppTextStyles.semiBold14.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _makeEmergencyCall(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Call 112',
                style: AppTextStyles.semiBold14.copyWith(
                  color: Colors.white,
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
    // Only show SOS section when trip is in progress
    if (!isInProgress) {
      return SizedBox.shrink();
    }

    return Container(
      padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
        gradient: LinearGradient(
          colors: [
            Colors.red.shade700,
            Colors.red.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emergency,
                color: Colors.white,
                size: MyResponsive.fontSize(value: 24),
              ),
              SizedBox(width: MyResponsive.width(value: 8)),
              Text(
                'Emergency SOS',
                style: AppTextStyles.bold18.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Text(
            'Need immediate help? Tap the button below to call emergency services.',
            style: AppTextStyles.medium14.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 16)),
          ElevatedButton.icon(
            onPressed: () => _showEmergencyConfirmation(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red.shade700,
              minimumSize:
                  Size(double.infinity, MyResponsive.height(value: 56)),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MyResponsive.radius(value: 12)),
              ),
              elevation: 4,
            ),
            icon: Icon(
              Icons.phone,
              size: MyResponsive.fontSize(value: 24),
            ),
            label: Text(
              'Call 112 - Emergency',
              style: AppTextStyles.bold18.copyWith(
                color: Colors.red.shade700,
              ),
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Container(
            padding:
                MyResponsive.paddingSymmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius:
                  BorderRadius.circular(MyResponsive.radius(value: 8)),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: MyResponsive.fontSize(value: 18),
                ),
                SizedBox(width: MyResponsive.width(value: 8)),
                Expanded(
                  child: Text(
                    'This will directly call emergency services. Use only in case of real emergency.',
                    style: AppTextStyles.medium12.copyWith(
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

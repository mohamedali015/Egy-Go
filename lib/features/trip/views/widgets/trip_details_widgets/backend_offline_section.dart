import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Widget to show when backend is unreachable
/// Provides retry functionality without crashing the app
class BackendOfflineSection extends StatelessWidget {
  const BackendOfflineSection({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 12),
      padding: MyResponsive.paddingSymmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyResponsive.radius(value: 12)),
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cloud_off,
                color: Colors.orange.shade700,
                size: 24,
              ),
              SizedBox(width: MyResponsive.width(value: 12)),
              Expanded(
                child: Text(
                  'Connection Issue',
                  style: AppTextStyles.bold16.copyWith(
                    color: Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 12)),
          Text(
            'Unable to connect to server. Your payment may have been processed successfully, but we cannot verify the status right now.',
            style: AppTextStyles.regular14.copyWith(
              color: Colors.orange.shade800,
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 16)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Retry Connection',
                style: AppTextStyles.semiBold14.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(height: MyResponsive.height(value: 8)),
          Text(
            'Tip: Check back in a few minutes. The server may be temporarily unavailable.',
            style: AppTextStyles.regular12.copyWith(
              color: Colors.orange.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

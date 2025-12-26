import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Payment Success Screen
/// Shown after Stripe payment completes successfully
/// CRITICAL: Do NOT call any APIs here - socket will update automatically
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key, required this.tripId});

  final String tripId;

  static const String routeName = "paymentSuccess";

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 3 seconds then navigate back to trip details
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(
          context,
          '/tripDetails',
          arguments: widget.tripId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: MyResponsive.paddingSymmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                ),

                SizedBox(height: MyResponsive.height(value: 32)),

                // Success Title
                Text(
                  'Payment Successful!',
                  style: AppTextStyles.bold24.copyWith(color: Colors.green),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: MyResponsive.height(value: 16)),

                // Description
                Text(
                  'Your payment has been processed successfully.',
                  style:
                      AppTextStyles.regular16.copyWith(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: MyResponsive.height(value: 24)),

                // Info Box
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your trip status will update automatically. Redirecting you back...',
                          style: AppTextStyles.regular14.copyWith(
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: MyResponsive.height(value: 32)),

                // Loading indicator
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),

                SizedBox(height: MyResponsive.height(value: 16)),

                Text(
                  'Redirecting in 3 seconds...',
                  style: AppTextStyles.regular14.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

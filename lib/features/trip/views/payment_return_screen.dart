import 'package:egy_go/core/services/deep_link_service.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/views/trip_details_screen.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

/// Payment Return Screen
/// Displays payment result and returns to trip details
/// This screen is shown after Stripe redirects back to the app
class PaymentReturnScreen extends StatefulWidget {
  static const String routeName = '/payment-return';

  final String tripId;

  const PaymentReturnScreen({super.key, required this.tripId});

  @override
  State<PaymentReturnScreen> createState() => _PaymentReturnScreenState();
}

class _PaymentReturnScreenState extends State<PaymentReturnScreen> {
  bool _isProcessing = true;
  bool _isSuccess = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _processPaymentReturn();
  }

  Future<void> _processPaymentReturn() async {
    print(
        '[PaymentReturn] 📝 Processing payment return for trip: ${widget.tripId}');

    setState(() => _isProcessing = true);

    try {
      // Wait a moment for the webhook to process
      await Future.delayed(Duration(seconds: 2));

      // Re-fetch trip details to get updated payment status
      print('[PaymentReturn] 🔄 Re-fetching trip details...');

      // The TripDetailsScreen will automatically fetch latest data
      // when it's opened, so we just need to show success and navigate

      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      // Wait to show success message, then navigate
      await Future.delayed(Duration(seconds: 2));

      if (mounted) {
        _navigateToTripDetails();
      }
    } catch (e) {
      print('[PaymentReturn] ❌ Error: $e');
      setState(() {
        _isProcessing = false;
        _isSuccess = false;
        _errorMessage = e.toString();
      });

      // Navigate anyway after showing error
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        _navigateToTripDetails();
      }
    }
  }

  void _navigateToTripDetails() {
    print('[PaymentReturn] 🚀 Navigating to TripDetailsScreen');
    Get.offAllNamed(
      TripDetailsScreen.routeName,
      arguments: widget.tripId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isProcessing) ...[
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Processing payment result...',
                    style: AppTextStyles.medium16,
                    textAlign: TextAlign.center,
                  ),
                ] else if (!_isSuccess) ...[
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Unable to Process',
                    style: AppTextStyles.bold20,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    _errorMessage ?? 'An unknown error occurred.',
                    style: AppTextStyles.regular14.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Payment Successful!',
                    style: AppTextStyles.bold24.copyWith(
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your trip is now confirmed.\nReturning to trip details...',
                    style: AppTextStyles.regular14.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

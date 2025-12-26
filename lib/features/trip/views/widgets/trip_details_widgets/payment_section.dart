import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// CRITICAL: This widget follows the STRICT payment contract:
/// 1. NEVER stores checkoutUrl or sessionId
/// 2. NEVER polls payment status
/// 3. NEVER modifies trip.status locally
/// 4. Payment confirmation comes ONLY from backend webhook via socket
class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key, required this.trip});

  final TripModel trip;

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  bool _isProcessing = false;

  /// Check if trip is ready for payment
  /// MUST be: status = 'awaiting_payment' AND paymentStatus = 'pending' or 'unpaid'
  bool get _canPay {
    final status = widget.trip.status?.toLowerCase();
    final paymentStatus = widget.trip.paymentStatus?.toLowerCase();

    return status == 'awaiting_payment' &&
        (paymentStatus == 'pending' || paymentStatus == 'unpaid');
  }

  /// Check if payment is already completed
  bool get _isPaid {
    return widget.trip.paymentStatus?.toLowerCase() == 'paid';
  }

  /// Handle payment button press
  /// STRICT CONTRACT:
  /// 1. Call POST /api/tourist/trips/{tripId}/create-checkout-session
  /// 2. Immediately open checkoutUrl using url_launcher
  /// 3. DO NOT save checkoutUrl or sessionId
  /// 4. DO NOT poll for status
  /// 5. Socket will update UI when webhook confirms payment
  Future<void> _handlePayNow() async {
    if (!_canPay || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final cubit = TripDetailsCubit.get(context);
      final tripId = widget.trip.sId;

      if (tripId == null) {
        throw Exception('Trip ID is null');
      }

      print('[PaymentSection] 💳 Creating checkout session for trip: $tripId');

      // Call backend to create Stripe checkout session
      final result = await cubit.repo.createCheckoutSession(tripId);

      result.fold(
        (error) {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
        },
        (sessionResponse) async {
          final checkoutUrl = sessionResponse.data?.checkoutUrl;

          if (checkoutUrl == null || checkoutUrl.isEmpty) {
            throw Exception('Checkout URL is empty');
          }

          print('[PaymentSection] ✅ Checkout session created');
          print('[PaymentSection] 🔗 Opening Stripe Checkout...');
          print(
              '[PaymentSection] 🔗 URL: ${checkoutUrl.substring(0, checkoutUrl.length > 100 ? 100 : checkoutUrl.length)}...');

          // IMPORTANT: Open Stripe Checkout immediately
          // DO NOT store the URL or session ID
          final uri = Uri.parse(checkoutUrl);

          try {
            // Try to launch with external browser mode
            final launched = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );

            if (!launched) {
              // If external application fails, try platform default
              print(
                  '[PaymentSection] ⚠️ External application failed, trying platform default...');
              final launchedDefault = await launchUrl(
                uri,
                mode: LaunchMode.platformDefault,
              );

              if (!launchedDefault) {
                throw Exception('Could not launch payment page in any mode');
              }
            }

            print('[PaymentSection] 🌐 Stripe Checkout opened in browser');

            // Show instruction dialog
            if (mounted) {
              _showPaymentInstructionDialog();
            }
          } catch (launchError) {
            print('[PaymentSection] ❌ Failed to launch URL: $launchError');

            // Try one more time with canLaunchUrl check
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              print(
                  '[PaymentSection] 🌐 Stripe Checkout opened (fallback method)');
              if (mounted) {
                _showPaymentInstructionDialog();
              }
            } else {
              throw Exception(
                  'Cannot open payment page. Please ensure you have a browser installed.');
            }
          }
        },
      );
    } catch (e) {
      print('[PaymentSection] ❌ Payment error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  /// Show dialog with payment instructions
  /// CRITICAL: Do NOT poll or check status here
  /// Socket will automatically update UI when webhook processes payment
  void _showPaymentInstructionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.payment, color: AppColors.primary),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Payment in Progress',
                style: AppTextStyles.semiBold16,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete your payment in the browser window.',
                style: AppTextStyles.medium14,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Important:',
                            style: AppTextStyles.semiBold14.copyWith(
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'After payment, your trip status will update automatically. No need to refresh!',
                      style: AppTextStyles.regular12.copyWith(
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only show payment section when status is awaiting_payment
    if (widget.trip.status?.toLowerCase() != 'awaiting_payment') {
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
          // Header
          Row(
            children: [
              Icon(
                Icons.payment,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: MyResponsive.width(value: 8)),
              Text(
                'Payment Required',
                style: AppTextStyles.bold18.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: MyResponsive.height(value: 16)),

          // Payment status info
          if (_isPaid) ...[
            // Payment already completed
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment Confirmed',
                      style: AppTextStyles.semiBold14.copyWith(
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_canPay) ...[
            // Ready for payment
            Text(
              'Your trip has been accepted by the guide. Complete payment to confirm your booking.',
              style: AppTextStyles.regular14.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: MyResponsive.height(value: 20)),

            // Negotiated price display
            if (widget.trip.meta?.negotiatedPrice != null) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trip Price',
                      style: AppTextStyles.semiBold16,
                    ),
                    Text(
                      '\$${widget.trip.meta!.negotiatedPrice!.toStringAsFixed(2)}',
                      style: AppTextStyles.bold20.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MyResponsive.height(value: 20)),
            ],

            // Pay Now button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _handlePayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isProcessing
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Pay Now',
                            style: AppTextStyles.semiBold16.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ] else ...[
            // Payment status not ready
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment status: ${widget.trip.paymentStatus ?? "Unknown"}',
                      style: AppTextStyles.medium14.copyWith(
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// DONE: Stripe Payment Integration (following strict contract)
// - NEVER stores sessionId or checkoutUrl
// - NEVER polls payment status
// - NEVER modifies trip.status locally
// - Opens Stripe Checkout immediately via url_launcher
// - Socket updates UI when webhook confirms payment

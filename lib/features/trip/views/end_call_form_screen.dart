import 'package:egy_go/core/helper/get_it.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/trip/data/repos/trip_repo.dart';
import 'package:egy_go/features/trip/manager/call_cubit/call_cubit.dart';
import 'package:egy_go/features/trip/manager/call_cubit/call_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndCallFormScreen extends StatelessWidget {
  const EndCallFormScreen({
    super.key,
    required this.callId,
    required this.tripId,
  });

  final String callId;
  final String tripId;

  static const String routeName = "endCallForm";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CallCubit(getIt<TripRepo>()),
      child: _EndCallFormContent(callId: callId, tripId: tripId),
    );
  }
}

class _EndCallFormContent extends StatefulWidget {
  const _EndCallFormContent({
    required this.callId,
    required this.tripId,
  });

  final String callId;
  final String tripId;

  @override
  State<_EndCallFormContent> createState() => _EndCallFormContentState();
}

class _EndCallFormContentState extends State<_EndCallFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedReason = 'completed';
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _summaryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please agree to the terms'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validation passed - prepare form data
      double? negotiatedPrice = _priceController.text.isNotEmpty
          ? double.tryParse(_priceController.text)
          : null;

      // Always call endCall API
      context.read<CallCubit>().endCall(
            widget.callId,
            _selectedReason,
            _summaryController.text,
            negotiatedPrice,
            _agreedToTerms,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'End Call Summary',
          style: AppTextStyles.semiBold20,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CallCubit, CallState>(
        listener: (context, state) {
          if (state is CallEnded) {
            // Handle based on endReason
            if (_selectedReason == 'cancelled') {
              // For cancelled: call cancelTrip to set trip status to CANCELLED
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Call ended. Cancelling trip...'),
                  backgroundColor: Colors.orange,
                ),
              );
              // Navigate back and trigger trip cancellation
              Navigator.pop(context,
                  {'action': 'cancel', 'reason': 'Call was cancelled'});
            } else if (_selectedReason == 'completed') {
              // For completed: Trip status → WAITING (handled by backend)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate back to trip details with refresh
              Navigator.pop(context, true);
            } else if (_selectedReason == 'timeout') {
              // For timeout: No trip status change
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.blue,
                ),
              );
              // Navigate back to trip details with refresh
              Navigator.pop(context, true);
            }
          } else if (state is CallEndFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // DONE: End Call logic
        builder: (context, state) {
          if (state is CallEnding) {
            return CustomLoadingIndicator();
          }

          return SingleChildScrollView(
            padding: MyResponsive.paddingSymmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MyResponsive.height(value: 24)),
                  Text(
                    'Call Status',
                    style: AppTextStyles.semiBold18,
                  ),
                  SizedBox(height: MyResponsive.height(value: 12)),
                  DropdownButtonFormField<String>(
                    value: _selectedReason,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                      DropdownMenuItem(
                        value: 'cancelled',
                        child: Text('Cancelled'),
                      ),
                      DropdownMenuItem(
                        value: 'timeout',
                        child: Text('Timeout'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a call status';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MyResponsive.height(value: 20)),
                  Text(
                    'Summary',
                    style: AppTextStyles.semiBold18,
                  ),
                  SizedBox(height: MyResponsive.height(value: 12)),
                  TextFormField(
                    controller: _summaryController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Describe what was discussed...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please provide a summary';
                      }
                      if (value.trim().length < 10) {
                        return 'Summary must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MyResponsive.height(value: 20)),
                  Text(
                    'Negotiated Price (Optional)',
                    style: AppTextStyles.semiBold18,
                  ),
                  SizedBox(height: MyResponsive.height(value: 12)),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter agreed price',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Please enter a valid price';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MyResponsive.height(value: 20)),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the terms and conditions discussed during the call',
                          style: AppTextStyles.regular14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MyResponsive.height(value: 32)),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: AppTextStyles.semiBold16
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: MyResponsive.height(value: 24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// DONE: End Call form UI

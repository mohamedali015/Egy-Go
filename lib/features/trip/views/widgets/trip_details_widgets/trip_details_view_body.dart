import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/home/views/app_home_view.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_cubit.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_state.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/trip_info_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/guide_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/trip_actions_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/call_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/proposal_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/waiting_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/payment_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/backend_offline_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/chat_section.dart';
import 'package:egy_go/features/trip/views/agora_call_screen.dart';
import 'package:egy_go/features/trip/views/end_call_form_screen.dart';
import 'package:egy_go/features/trip/views/trips_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripDetailsViewBody extends StatelessWidget {
  const TripDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripDetailsCubit, TripDetailsState>(
      listener: (context, state) {
        if (state is TripCancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to trips screen and refresh
          MyNavigator.goTo(
            screen: AppHomeView(
              initialIndex: 1,
            ),
            isReplace: true,
          );
        } else if (state is TripDetailsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is SocketConnectionError) {
          // Show socket connection error but don't block UI
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Real-time updates unavailable: ${state.errorMessage}'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
        } else if (state is CallInitiatedSuccess) {
          // Navigate to Agora call screen
          final callResponse = state.callResponse;
          if (callResponse.token != null) {
            Navigator.pushNamed(
              context,
              AgoraCallScreen.routeName,
              arguments: {
                'appId': callResponse.token!.appId!,
                'channelName': callResponse.token!.channelName!,
                'token': callResponse.token!.token!,
                'uid': callResponse.token!.uid!,
                'callId': callResponse.callId!,
                'tripId': callResponse.tripId!,
              },
            ).then((value) {
              // Restore TripDetails state after returning from call screen
              final cubit = TripDetailsCubit.get(context);
              cubit.restoreTripDetailsState();

              // After call ends, show end call form
              Navigator.pushNamed(
                context,
                EndCallFormScreen.routeName,
                arguments: {
                  'callId': callResponse.callId!,
                  'tripId': callResponse.tripId!,
                },
              ).then((result) {
                final cubit = TripDetailsCubit.get(context);

                // Check if result is a Map with 'action' key (for cancelled)
                if (result is Map && result['action'] == 'cancel') {
                  // Call cancelTrip API to set trip status to CANCELLED
                  if (cubit.currentTrip?.sId != null) {
                    cubit.cancelTrip(
                      cubit.currentTrip!.sId!,
                      result['reason'] ?? 'Call was cancelled',
                    );
                  }
                } else if (result == true) {
                  // For completed or timeout: refresh trip details
                  if (cubit.currentTrip?.sId != null) {
                    cubit.fetchTripDetails(cubit.currentTrip!.sId!);
                  }
                }
              });
            });
          }
        } else if (state is CallInitiationFailed) {
          // State already restored in cubit, just show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TripDetailsLoading || state is CallInitiating) {
          return CustomLoadingIndicator();
        } else if (state is TripDetailsFailure && state is! TripCancelling) {
          // Check if it's a connection error (backend offline)
          final isConnectionError =
              state.errorMessage.contains('Cannot connect to server') ||
                  state.errorMessage.contains('No internet connection');

          final cubit = TripDetailsCubit.get(context);

          // If we have cached trip data, show it with offline banner
          if (isConnectionError && cubit.currentTrip != null) {
            final trip = cubit.currentTrip!;

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: MyResponsive.paddingSymmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MyResponsive.height(value: 16)),

                  // Show offline banner at top
                  BackendOfflineSection(
                    onRetry: () {
                      if (trip.sId != null) {
                        cubit.fetchTripDetails(trip.sId!);
                      }
                    },
                  ),

                  SizedBox(height: MyResponsive.height(value: 16)),
                  TripInfoSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  GuideSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  ChatSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  WaitingSection(trip: trip),
                  if (trip.status?.toLowerCase() == 'pending_confirmation')
                    SizedBox(height: MyResponsive.height(value: 24)),
                  CallSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  ProposalSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  PaymentSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  TripActionsSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                ],
              ),
            );
          }

          // Otherwise show error message
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular14,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    final cubit = TripDetailsCubit.get(context);
                    if (cubit.currentTrip?.sId != null) {
                      cubit.fetchTripDetails(cubit.currentTrip!.sId!);
                    }
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is TripDetailsSuccess ||
            state is TripCancelling ||
            state is CallInitiatedSuccess ||
            state is CallInitiationFailed) {
          final cubit = TripDetailsCubit.get(context);
          final trip = cubit.currentTrip;

          if (trip == null) {
            return Center(child: Text('Trip data not available'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              final cubit = TripDetailsCubit.get(context);
              if (cubit.currentTrip?.sId != null) {
                print('[TripDetailsViewBody] 🔄 Manual refresh triggered');
                await cubit.fetchTripDetails(cubit.currentTrip!.sId!);
              }
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: MyResponsive.paddingSymmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MyResponsive.height(value: 16)),
                  TripInfoSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  GuideSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  ChatSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  WaitingSection(trip: trip),
                  if (trip.status?.toLowerCase() == 'pending_confirmation')
                    SizedBox(height: MyResponsive.height(value: 24)),
                  CallSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  ProposalSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  PaymentSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  TripActionsSection(trip: trip),
                  SizedBox(height: MyResponsive.height(value: 24)),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

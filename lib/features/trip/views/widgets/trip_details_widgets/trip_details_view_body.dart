import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_cubit.dart';
import 'package:egy_go/features/trip/manager/trip_details_cubit/trip_details_state.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/trip_info_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/guide_section.dart';
import 'package:egy_go/features/trip/views/widgets/trip_details_widgets/trip_actions_section.dart';
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
          // Navigate back to trips screen
          Navigator.pop(context);
        } else if (state is TripDetailsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TripDetailsLoading) {
          return CustomLoadingIndicator();
        } else if (state is TripDetailsFailure && state is! TripCancelling) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else if (state is TripDetailsSuccess || state is TripCancelling) {
          final cubit = TripDetailsCubit.get(context);
          final trip = cubit.currentTrip;

          if (trip == null) {
            return Center(child: Text('Trip data not available'));
          }

          return SingleChildScrollView(
            padding: MyResponsive.paddingSymmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MyResponsive.height(value: 16)),
                TripInfoSection(trip: trip),
                SizedBox(height: MyResponsive.height(value: 24)),
                GuideSection(trip: trip),
                SizedBox(height: MyResponsive.height(value: 24)),
                TripActionsSection(trip: trip),
                SizedBox(height: MyResponsive.height(value: 24)),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/features/trip/manager/trips_cubit/trips_cubit.dart';
import 'package:egy_go/features/trip/manager/trips_cubit/trips_state.dart';
import 'package:egy_go/features/trip/views/widgets/trips_widgets/trip_filter_chips.dart';
import 'package:egy_go/features/trip/views/widgets/trips_widgets/trip_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsViewBody extends StatelessWidget {
  const TripsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await TripsCubit.get(context).fetchTrips();
      },
      child: BlocBuilder<TripsCubit, TripsState>(
        builder: (context, state) {
          if (state is TripsLoading) {
            return CustomLoadingIndicator();
          } else if (state is TripsFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is TripsSuccess) {
            return Padding(
              padding: MyResponsive.paddingSymmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MyResponsive.height(value: 16)),
                  TripFilterChips(),
                  SizedBox(height: MyResponsive.height(value: 20)),
                  Expanded(
                    child: TripListView(trips: state.trips),
                  ),
                  SizedBox(height: MyResponsive.height(value: 16)),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

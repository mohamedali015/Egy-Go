import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/views/widgets/trips_widgets/trip_item.dart';
import 'package:flutter/material.dart';

class TripListView extends StatelessWidget {
  const TripListView({super.key, required this.trips});

  final List<TripModel> trips;

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(
        child: Text('No trips available'),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return TripItem(trip: trips[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: MyResponsive.height(value: 12),
        );
      },
      itemCount: trips.length,
    );
  }
}

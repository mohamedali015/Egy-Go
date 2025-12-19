import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/trip/views/widgets/trips_view_body.dart';
import 'package:flutter/material.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.trips),
        centerTitle: true,
      ),
      body: TripsViewBody(),
    );
  }
}

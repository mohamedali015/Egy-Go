import 'package:flutter/material.dart';

import 'widgets/places_view_body.dart';

class PlacesView extends StatelessWidget {
  const PlacesView({super.key});

  static const String routeName = 'PlacesView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PlacesViewBody(),
    );
  }
}

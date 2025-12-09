import 'package:egy_go/features/home/views/widgets/place_item.dart';
import 'package:flutter/material.dart';
import '../../../../core/helper/my_responsive.dart';

class PlacesListView extends StatelessWidget {
  const PlacesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return PlaceItem();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: MyResponsive.height(value: 16),
        );
      },
      itemCount: 10,
    );
  }
}

import 'package:egy_go/features/home/views/widgets/place_item.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:flutter/material.dart';
import '../../../../core/helper/my_responsive.dart';

class PlacesListView extends StatelessWidget {
  const PlacesListView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = PlacesCubit.get(context);
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return PlaceItem(
          place: cubit.places[index],
        );
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

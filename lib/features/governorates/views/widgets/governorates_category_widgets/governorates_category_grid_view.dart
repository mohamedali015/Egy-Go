import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/places/views/places_view.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/utils/app_assets.dart';
import 'governorates_category_grid_view_item.dart';

class GovernoratesCategoryGridView extends StatelessWidget {
  const GovernoratesCategoryGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {
        "name": AppStrings.historical,
        "title": AppStrings.historicalTitle,
        "icon": AppAssets.historicalIcon,
      },
      {
        "name": AppStrings.entertainment,
        "title": AppStrings.entertainmentTitle,
        "icon": AppAssets.entertainmentIcon,
      },
      {
        "name": AppStrings.hotels,
        "title": AppStrings.hotelsTitle,
        "icon": AppAssets.hotelsIcon,
      },
      {
        "name": AppStrings.events,
        "title": AppStrings.eventsTitle,
        "icon": AppAssets.eventsIcon,
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: MyResponsive.height(value: 12),
        crossAxisSpacing: MyResponsive.width(value: 12),
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, PlacesView.routeName);
          },
          child: GovernoratesCategoryGridViewItem(
            title: categories[index]["title"]!,
            icon: categories[index]["icon"]!,
            name: categories[index]["name"]!,
          ),
        );
      },
      itemCount: 4,
    );
  }
}

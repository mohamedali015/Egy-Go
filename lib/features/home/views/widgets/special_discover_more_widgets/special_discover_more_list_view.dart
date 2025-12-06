import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import 'special_discover_more_grid_view_item.dart';

class SpecialDiscoverMoreGridView extends StatelessWidget {
  const SpecialDiscoverMoreGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 163 / 214,
        mainAxisSpacing: MyResponsive.height(value: 12),
        crossAxisSpacing: MyResponsive.width(value: 12),
      ),
      itemBuilder: (context, index) {
        return SpecialDiscoverMoreListViewItem();
      },
      itemCount: 7,
    );
  }
}

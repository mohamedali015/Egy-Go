import 'package:flutter/material.dart';

import '../../../../core/helper/my_responsive.dart';
import 'governorate_item.dart';

class SpecialListView extends StatelessWidget {
  const SpecialListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MyResponsive.height(value: 250),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GovernorateItem();
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: MyResponsive.width(value: 8),
          );
        },
        itemCount: 7,
      ),
    );
  }
}

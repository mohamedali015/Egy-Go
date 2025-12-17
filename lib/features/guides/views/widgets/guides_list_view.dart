import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:flutter/material.dart';

import 'guide_item.dart';

class GuidesListView extends StatelessWidget {
  const GuidesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return GuideItem();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: MyResponsive.height(value: 12),
        );
      },
      itemCount: 10,
    );
  }
}

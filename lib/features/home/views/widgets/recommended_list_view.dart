import 'package:flutter/material.dart';
import '../../../../core/helper/my_responsive.dart';
import 'recommended_list_view_item.dart';

class RecommendedListView extends StatelessWidget {
  const RecommendedListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return RecommendedListViewItem();
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

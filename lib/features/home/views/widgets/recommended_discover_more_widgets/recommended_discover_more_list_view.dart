import 'package:flutter/material.dart';
import '../../../../../core/helper/my_responsive.dart';
import '../home_view_widgets/recommended_list_view_item.dart';

class RecommendedDiscoverMoreListView extends StatelessWidget {
  const RecommendedDiscoverMoreListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
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

import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/views/widgets/select_guide_widgets/select_guide_item.dart';
import 'package:flutter/material.dart';

class SelectGuideListView extends StatelessWidget {
  const SelectGuideListView({super.key, required this.guides});

  final List<Guide> guides;

  @override
  Widget build(BuildContext context) {
    if (guides.isEmpty) {
      return Center(
        child: Text('No guides available'),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return SelectGuideItem(guide: guides[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: MyResponsive.height(value: 12),
        );
      },
      itemCount: guides.length,
    );
  }
}

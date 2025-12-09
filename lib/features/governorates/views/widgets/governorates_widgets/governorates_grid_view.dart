import 'package:flutter/material.dart';
import '../../../../../core/helper/my_responsive.dart';
import '../../../../home/views/widgets/governorate_item.dart';

class GovernoratesGridView extends StatelessWidget {
  const GovernoratesGridView({super.key});

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
        return GovernorateItem();
      },
      itemCount: 7,
    );
  }
}

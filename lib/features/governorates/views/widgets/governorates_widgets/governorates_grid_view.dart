import 'package:flutter/material.dart';
import '../../../../../core/helper/my_responsive.dart';
import '../../../../home/views/widgets/governorate_item.dart';
import '../../../manager/governorates_cubit/governorates_cubit.dart';

class GovernoratesGridView extends StatelessWidget {
  const GovernoratesGridView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = GovernoratesCubit.get(context);
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 200 / 170,
        mainAxisSpacing: MyResponsive.height(value: 12),
        crossAxisSpacing: MyResponsive.width(value: 12),
      ),
      itemBuilder: (context, index) {
        return GovernorateItem(governorate: cubit.governorates[index]);
      },
      itemCount: cubit.governorates.length,
    );
  }
}

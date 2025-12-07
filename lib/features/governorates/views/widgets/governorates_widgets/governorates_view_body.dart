import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_text_form_field.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/governorates/views/widgets/governorates_widgets/governorates_grid_view.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_text_styles.dart';

class GovernoratesViewBody extends StatelessWidget {
  const GovernoratesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MyResponsive.height(value: 10),
          ),
          CustomTextFormField(
            type: TextFieldType.search,
            onChanged: (value) {},
          ),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          Text(
            AppStrings.governorates,
            style: AppTextStyles.bold16,
          ),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          Expanded(
            child: GovernoratesGridView(),
          ),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
        ],
      ),
    );
  }
}

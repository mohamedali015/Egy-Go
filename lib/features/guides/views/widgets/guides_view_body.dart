import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_text_form_field.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/views/widgets/guides_list_view.dart';
import 'package:flutter/material.dart';

class GuidesViewBody extends StatelessWidget {
  const GuidesViewBody({super.key});

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
            AppStrings.popularGuides,
            style: AppTextStyles.bold16,
          ),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          Expanded(
            child: GuidesListView(),
          ),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
        ],
      ),
    );
  }
}

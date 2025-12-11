import 'package:egy_go/core/shared_widgets/custom_text_form_field.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/home_search/manager/home_search_cubit/home_search_cubit.dart';
import 'package:egy_go/features/home_search/view/widgets/search_result_list_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/helper/my_responsive.dart';

class HomeSearchViewBody extends StatelessWidget {
  const HomeSearchViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = HomeSearchCubit.get(context);
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            type: TextFieldType.search,
            onChanged: (value) => cubit.homeSearchPlaces(value),
            focusNode: cubit.focusNode,
          ),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          Text(AppStrings.searchResult, style: AppTextStyles.bold16),
          SizedBox(
            height: MyResponsive.height(value: 20),
          ),
          const Expanded(
            child: SearchResultListView(),
          ),
        ],
      ),
    );
  }
}

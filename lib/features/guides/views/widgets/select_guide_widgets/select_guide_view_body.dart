import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_cubit.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_state.dart';
import 'package:egy_go/features/guides/views/widgets/select_guide_widgets/language_filter_section.dart';
import 'package:egy_go/features/guides/views/widgets/select_guide_widgets/select_guide_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectGuideViewBody extends StatelessWidget {
  const SelectGuideViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectGuideCubit, SelectGuideState>(
      builder: (context, state) {
        if (state is SelectGuideLoading) {
          return CustomLoadingIndicator();
        } else if (state is SelectGuideFailure) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else if (state is SelectGuideSuccess) {
          final cubit = SelectGuideCubit.get(context);
          return Padding(
            padding: MyResponsive.paddingSymmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MyResponsive.height(value: 16)),
                LanguageFilterSection(),
                SizedBox(height: MyResponsive.height(value: 20)),
                Expanded(
                  child: SelectGuideListView(guides: cubit.filteredGuides),
                ),
                SizedBox(height: MyResponsive.height(value: 16)),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

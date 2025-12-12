import 'package:egy_go/core/shared_widgets/custom_error_widget.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/my_responsive.dart';
import 'governorate_item.dart';

class SpecialListView extends StatelessWidget {
  const SpecialListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MyResponsive.height(value: 140),
      child: BlocBuilder<GovernoratesCubit, GovernoratesState>(
        builder: (context, state) {
          if (state is GovernoratesSuccess) {
            if (state.governorates.isEmpty) {
              return CustomErrorWidget(errorMessage: AppStrings.noResults);
            } else {
              return ListView.separated(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GovernorateItem(
                    governorate: state.governorates[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: MyResponsive.width(value: 8),
                  );
                },
                itemCount: 7,
              );
            }
          } else if (state is GovernoratesFailure) {
            return CustomErrorWidget(errorMessage: state.errorMessage);
          } else {
            return CustomLoadingIndicator();
          }
        },
      ),
    );
  }
}

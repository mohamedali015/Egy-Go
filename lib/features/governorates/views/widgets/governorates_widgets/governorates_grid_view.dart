import 'package:egy_go/core/shared_widgets/custom_error_widget.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helper/my_responsive.dart';
import '../../../../home/views/widgets/governorate_item.dart';
import '../../../manager/governorates_cubit/governorates_cubit.dart';

class GovernoratesGridView extends StatelessWidget {
  const GovernoratesGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        if (state is GovernoratesSuccess) {
          if (state.governorates.isEmpty) {
            return CustomErrorWidget(errorMessage: AppStrings.noResults);
          } else {
            return GridView.builder(
              padding: EdgeInsets.zero,
              cacheExtent: 4000,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 200 / 170,
                mainAxisSpacing: MyResponsive.height(value: 12),
                crossAxisSpacing: MyResponsive.width(value: 12),
              ),
              itemBuilder: (context, index) {
                return GovernorateItem(
                  governorate: state.governorates[index],
                  index: index,
                );
              },
              itemCount: state.governorates.length,
            );
          }
        } else if (state is GovernoratesFailure) {
          return SizedBox(
            height: MyResponsive.height(value: 210),
            child: CustomErrorWidget(errorMessage: state.errorMessage),
          );
        } else if (state is GovernoratesLoading) {
          return SizedBox(
            height: MyResponsive.height(value: 210),
            child: const CustomLoadingIndicator(),
          );
        } else {
          return CustomErrorWidget(errorMessage: AppStrings.noResults);
        }
      },
    );
  }
}

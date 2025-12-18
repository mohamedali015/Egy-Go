import 'package:egy_go/core/shared_widgets/custom_error_widget.dart';
import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/features/home/views/widgets/place_item.dart';
import 'package:egy_go/features/places/manager/place_category_cubit/place_category_cubit.dart';
import 'package:egy_go/features/places/manager/place_category_cubit/place_category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/my_responsive.dart';
import '../../../../core/utils/app_strings.dart';

class PlacesListView extends StatelessWidget {
  const PlacesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceCategoryCubit, PlaceCategoryState>(
      builder: (context, state) {
        if (state is PlacesCategoryLoadSuccess) {
          if (state.places.isEmpty) {
            return SizedBox(
              height: MyResponsive.height(value: 170),
              child: CustomErrorWidget(errorMessage: AppStrings.noResults),
            );
          } else {
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return PlaceItem(
                  place: state.places[index],
                  index: index,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: MyResponsive.height(value: 16),
                );
              },
              itemCount: state.places.length,
            );
          }
        } else if (state is PlacesCategoryLoadError) {
          return SizedBox(
            height: MyResponsive.height(value: 170),
            child: CustomErrorWidget(errorMessage: state.error),
          );
        } else {
          return SizedBox(
            height: MyResponsive.height(value: 170),
            child: CustomLoadingIndicator(),
          );
        }
      },
    );
  }
}

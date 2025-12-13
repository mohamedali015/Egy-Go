import 'package:egy_go/core/shared_widgets/custom_loading_indicator.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/my_responsive.dart';
import '../../../../core/shared_widgets/custom_error_widget.dart';
import 'place_item.dart';

class RecommendedListView extends StatelessWidget {
  const RecommendedListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesCubit, PlacesState>(
      builder: (context, state) {
        if (state is PlacesLoadSuccess) {
          if (state.places.isEmpty) {
            return SizedBox(
              height: MyResponsive.height(value: 170),
              child: CustomErrorWidget(errorMessage: AppStrings.noResults),
            );
          } else {
            return ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
              itemCount: 10,
            );
          }
        } else if (state is PlacesLoadError) {
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

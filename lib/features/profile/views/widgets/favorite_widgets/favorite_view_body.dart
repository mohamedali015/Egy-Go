import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/shared_widgets/custom_error_widget.dart';
import '../../../../../core/user/manager/user_cubit/user_cubit.dart';
import '../../../../home/views/widgets/place_item.dart';
import '../../../manager/favorite_cubit/favorite_cubit.dart';
import '../../../manager/favorite_cubit/favorite_state.dart';

class FavoriteViewBody extends StatelessWidget {
  const FavoriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = UserCubit.get(context);

    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 20),
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          FavoriteCubit.get(context)
              .init(UserCubit.get(context).favoritePlaces);
        },
        child: Column(
          children: [
            SizedBox(height: MyResponsive.height(value: 10)),
            Expanded(
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  final cubit = FavoriteCubit.get(context);

                  if (cubit.favoritePlace.isEmpty) {
                    return CustomErrorWidget(
                        errorMessage: 'No favorite cars added yet.');
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: cubit.favoritePlace.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: MyResponsive.height(value: 20)),
                    itemBuilder: (context, index) {
                      final place = cubit.favoritePlace[index];

                      return PlaceItem(
                        place: place,
                        index: index,
                        isFavorite: true,
                        onTap: () {
                          cubit.removeFromFavorite(
                            place: place,
                            userCubit: userCubit,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

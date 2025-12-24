import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/user/manager/user_cubit/user_cubit.dart';
import '../manager/favorite_cubit/favorite_cubit.dart';
import 'widgets/favorite_widgets/favorite_view_body.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  static const String routeName = 'FavoriteView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FavoriteCubit()..init(UserCubit.get(context).favoritePlaces),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Favorites'),
          centerTitle: true,
        ),
        body: FavoriteViewBody(),
      ),
    );
  }
}

import 'package:egy_go/core/helper/get_it.dart';
import 'package:egy_go/features/home_search/data/repo/home_search_repo.dart';
import 'package:egy_go/features/home_search/manager/home_search_cubit/home_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/home_search_view_body.dart';

class HomeSearchView extends StatelessWidget {
  const HomeSearchView({super.key});

  static const String routeName = 'home_search_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeSearchCubit(getIt<HomeSearchRepo>())..focusOnTextField(context),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: HomeSearchViewBody(),
        ),
      ),
    );
  }
}

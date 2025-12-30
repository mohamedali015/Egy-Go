import 'package:egy_go/core/helper/get_it.dart';
import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/my_snackbar.dart';
import 'package:egy_go/core/shared_widgets/custom_progress_hud.dart';
import 'package:egy_go/features/create_trip/data/repos/create_trip_form_repo/create_trip_form_repo.dart';
import 'package:egy_go/features/create_trip/manager/create_trip_cubit/create_trip_cubit.dart';
import 'package:egy_go/features/create_trip/views/choose_guide_view.dart';
import 'package:egy_go/features/guides/views/guide_filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/create_trip_cubit/create_trip_state.dart';
import 'widgets/create_trip_form_widgets/create_trip_form_view_body.dart';

class CreateTripFormView extends StatelessWidget {
  static const String routeName = "create_trip_form";

  const CreateTripFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateTripCubit(getIt<CreateTripFormRepo>()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          body: BlocConsumer<CreateTripCubit, CreateTripState>(
            listener: (context, state) {
              if (state is CreateTripFailure) {
                MySnackbar.error(context, state.errorMessage);
              } else if (state is CreateTripSuccess) {
                MySnackbar.success(context, state.response.message!);
                MyNavigator.goTo(
                    screen: GuideFilterScreen(
                  tripId: state.response.trip!.sId!,
                ));
              }
            },
            builder: (context, state) {
              return CustomProgressHud(
                isLoading: state is CreateTripLoading,
                child: CreateTripFormViewBody(),
              );
            },
          ),
        );
      }),
    );
  }
}

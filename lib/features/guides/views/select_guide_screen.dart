import 'package:egy_go/core/helper/get_it.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_cubit.dart';
import 'package:egy_go/features/guides/views/widgets/select_guide_widgets/select_guide_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectGuideScreen extends StatelessWidget {
  const SelectGuideScreen({super.key, required this.tripId});

  final String tripId;

  static const String routeName = "selectGuide";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SelectGuideCubit(getIt<GuidesRepo>())..fetchTripGuides(tripId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Guide',
            style: AppTextStyles.semiBold20,
          ),
          centerTitle: true,
        ),
        body: SelectGuideViewBody(),
      ),
    );
  }
}

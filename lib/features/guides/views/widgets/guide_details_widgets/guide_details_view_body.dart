import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_cubit.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_state.dart';
import 'package:egy_go/features/guides/views/widgets/guide_details_widgets/guide_details_header.dart';
import 'package:egy_go/features/guides/views/widgets/guide_details_widgets/guide_info_section.dart';
import 'package:egy_go/features/home/views/app_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuideDetailsViewBody extends StatelessWidget {
  const GuideDetailsViewBody({super.key, required this.guide, this.tripId});

  final Guide guide;
  final String? tripId;

  @override
  Widget build(BuildContext context) {
    // Read-only mode if tripId is null
    final isReadOnly = tripId == null;

    if (isReadOnly) {
      // Simple read-only view without BlocConsumer
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: MyResponsive.paddingSymmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MyResponsive.height(value: 16)),
                  GuideDetailsHeader(guide: guide),
                  SizedBox(height: MyResponsive.height(value: 24)),
                  GuideInfoSection(guide: guide),
                  SizedBox(height: MyResponsive.height(value: 24)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Original interactive mode with select guide button
    return BlocConsumer<SelectGuideCubit, SelectGuideState>(
      listener: (context, state) {
        if (state is SelectGuideSelected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(state.response.message ?? 'Guide selected successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const AppHomeView(initialIndex: 1),
            ),
            (route) => false,
          );
        } else if (state is SelectGuideFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SelectGuideSelecting;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: MyResponsive.paddingSymmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MyResponsive.height(value: 16)),
                    GuideDetailsHeader(guide: guide),
                    SizedBox(height: MyResponsive.height(value: 24)),
                    GuideInfoSection(guide: guide),
                    SizedBox(height: MyResponsive.height(value: 24)),
                  ],
                ),
              ),
            ),
            SizedBox(height: MyResponsive.height(value: 20)),
            Padding(
              padding: MyResponsive.paddingSymmetric(horizontal: 20),
              child: CustomButton(
                title: isLoading ? 'Selecting...' : 'Select this Guide',
                onPressed: isLoading
                    ? null
                    : () {
                        final cubit = SelectGuideCubit.get(context);
                        cubit.selectGuide(tripId!, guide.sId ?? '');
                      },
              ),
            ),
            SizedBox(height: MyResponsive.height(value: 25)),
          ],
        );
      },
    );
  }
}

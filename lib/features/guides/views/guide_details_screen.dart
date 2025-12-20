import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/data/models/trip_guides_response_model.dart';
import 'package:egy_go/features/guides/views/widgets/guide_details_widgets/guide_details_view_body.dart';
import 'package:flutter/material.dart';

class GuideDetailsScreen extends StatelessWidget {
  const GuideDetailsScreen({super.key, required this.guide, this.tripId});

  final Guide guide;
  final String? tripId;

  static const String routeName = "guideDetails";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guide Details',
          style: AppTextStyles.semiBold20,
        ),
        centerTitle: true,
      ),
      body: GuideDetailsViewBody(guide: guide, tripId: tripId),
    );
  }
}

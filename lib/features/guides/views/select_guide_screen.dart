import 'package:egy_go/core/helper/get_it.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_cubit.dart';
import 'package:egy_go/features/guides/views/widgets/select_guide_widgets/select_guide_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectGuideScreen extends StatefulWidget {
  const SelectGuideScreen({
    super.key,
    required this.tripId,
    this.isLicensed,
    this.canEnterArchaeologicalSites,
  });

  final String tripId;
  final bool? isLicensed;
  final bool? canEnterArchaeologicalSites;

  static const String routeName = "selectGuide";

  @override
  State<SelectGuideScreen> createState() => _SelectGuideScreenState();
}

class _SelectGuideScreenState extends State<SelectGuideScreen> {
  @override
  void initState() {
    SelectGuideCubit.get(context).fetchTripGuides(
      widget.tripId,
      isLicensed: widget.isLicensed,
      canEnterArchaeologicalSites: widget.canEnterArchaeologicalSites,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Guide',
          style: AppTextStyles.semiBold20,
        ),
        centerTitle: true,
      ),
      body: SelectGuideViewBody(tripId: widget.tripId),
    );
  }
}

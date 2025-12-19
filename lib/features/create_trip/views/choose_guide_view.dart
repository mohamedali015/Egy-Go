import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/create_trip/views/widgets/choose_guide_widgets/choose_guide_view_body.dart';
import 'package:flutter/material.dart';

class ChooseGuideView extends StatelessWidget {
  const ChooseGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.chooseGuide),
        centerTitle: true,
      ),
      body: ChooseGuideViewBody(),
    );
  }
}

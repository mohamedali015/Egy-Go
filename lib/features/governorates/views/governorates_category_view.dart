import 'package:flutter/material.dart';

import 'widgets/governorates_category_widgets/governorates_category_view_body.dart';

class GovernoratesCategoryView extends StatelessWidget {
  const GovernoratesCategoryView({super.key});

  static const String routeName = 'governoratesCategoryView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GovernoratesCategoryViewBody(),
    );
  }
}

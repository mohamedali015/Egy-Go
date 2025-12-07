import 'package:flutter/material.dart';

import 'widgets/governorates_widgets/governorates_view_body.dart';

class GovernoratesView extends StatelessWidget {
  const GovernoratesView({super.key});

  static const String routeName = 'GovernoratesView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GovernoratesViewBody(),
    );
  }
}

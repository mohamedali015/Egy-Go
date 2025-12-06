import 'package:flutter/material.dart';

import 'widgets/recommended_discover_more_widgets/recommended_discover_more_view_body.dart';

class RecommendedDiscoverMoreView extends StatelessWidget {
  const RecommendedDiscoverMoreView({super.key});

  static const String routeName = 'RecommendedDiscoverMoreView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RecommendedDiscoverMoreViewBody(),
    );
  }
}

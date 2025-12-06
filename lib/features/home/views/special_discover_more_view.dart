import 'package:flutter/material.dart';
import 'widgets/special_discover_more_widgets/special_discover_more_view_body.dart';

class SpecialDiscoverMoreView extends StatelessWidget {
  const SpecialDiscoverMoreView({super.key});

  static const String routeName = 'SpecialDiscoverMoreView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpecialDiscoverMoreViewBody(),
    );
  }
}

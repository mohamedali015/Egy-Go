import 'package:egy_go/features/auth/views/widgets/get_started_widgets/get_started_view_body.dart';
import 'package:flutter/material.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});
  static const String routeName = 'get_started';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetStartedViewBody(),
      ),
    );
  }
}

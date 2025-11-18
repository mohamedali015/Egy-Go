import 'package:egy_go/features/splash_and_onboarding/views/widgets/splash_widgets/splash_view_body.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SplashViewBody(),
      ),
    );
  }
}

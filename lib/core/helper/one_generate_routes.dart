import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:egy_go/features/auth/views/register_view.dart';
import 'package:egy_go/features/splash_and_onboarding/views/on_boarding_view.dart';
import 'package:flutter/material.dart';

import '../../features/auth/views/widgets/reset_password_widgets/forget_password_flow.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case OnBoardingView.routeName:
      return MaterialPageRoute(
        builder: (_) => const OnBoardingView(),
        settings: settings,
      );

    case GetStartedView.routeName:
      return MaterialPageRoute(
        builder: (_) => const GetStartedView(),
        settings: settings,
      );

    case LoginView.routeName:
      return MaterialPageRoute(
        builder: (_) => const LoginView(),
        settings: settings,
      );

    case ForgetPasswordFlow.routeName:
      return MaterialPageRoute(
        builder: (_) => ForgetPasswordFlow(),
        settings: settings,
      );

    case RegisterView.routeName:
      return MaterialPageRoute(
        builder: (_) => const RegisterView(),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const GetStartedView(),
        settings: settings,
      );
  }
}

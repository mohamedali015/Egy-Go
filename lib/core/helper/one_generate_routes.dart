import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case GetStartedView.routeName:
      return MaterialPageRoute(builder: (_) => const GetStartedView());

    case LoginView.routeName:
      return MaterialPageRoute(builder: (_) => const LoginView());

    default:
      return MaterialPageRoute(builder: (_) => const LoginView());
  }
}

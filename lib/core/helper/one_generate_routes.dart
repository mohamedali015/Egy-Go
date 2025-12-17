import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:egy_go/features/auth/views/register_view.dart';
import 'package:egy_go/features/create_trip/views/create_trip_form_view.dart';
import 'package:egy_go/features/create_trip/views/create_trip_image_view.dart';
import 'package:egy_go/features/governorates/views/governorates_category_view.dart';
import 'package:egy_go/features/guides/views/guides_view.dart';
import 'package:egy_go/features/home_search/view/home_search_view.dart';
import 'package:egy_go/features/places/views/places_view.dart';
import 'package:egy_go/features/governorates/views/governorates_view.dart';
import 'package:egy_go/features/splash_and_onboarding/views/on_boarding_view.dart';
import 'package:egy_go/features/splash_and_onboarding/views/splash_view.dart';
import 'package:flutter/material.dart';

import '../../features/auth/views/widgets/reset_password_widgets/forget_password_flow.dart';
import '../../features/home/views/app_home_view.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(
        builder: (_) => const SplashView(),
        settings: settings,
      );

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

    case AppHomeView.routeName:
      return MaterialPageRoute(
        builder: (_) => const AppHomeView(),
        settings: settings,
      );

    case HomeSearchView.routeName:
      return MaterialPageRoute(
        builder: (_) => const HomeSearchView(),
        settings: settings,
      );

    case CreateTripImageView.routeName:
      return MaterialPageRoute(
        builder: (_) => const CreateTripImageView(),
        settings: settings,
      );

    case CreateTripFormView.routeName:
      return MaterialPageRoute(
        builder: (_) => const CreateTripFormView(),
        settings: settings,
      );

    case GovernoratesView.routeName:
      return MaterialPageRoute(
        builder: (_) => const GovernoratesView(),
        settings: settings,
      );

    case GovernoratesCategoryView.routeName:
      return MaterialPageRoute(
        builder: (_) => const GovernoratesCategoryView(),
        settings: settings,
      );

    case PlacesView.routeName:
      return MaterialPageRoute(
        builder: (_) => const PlacesView(),
        settings: settings,
      );

    case GuidesView.routeName:
      return MaterialPageRoute(
        builder: (_) => const GuidesView(),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const SplashView(),
        settings: settings,
      );
  }
}

import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:egy_go/features/auth/views/register_view.dart';
import 'package:egy_go/features/create_trip/views/create_trip_form_view.dart';
import 'package:egy_go/features/create_trip/views/create_trip_image_view.dart';
import 'package:egy_go/features/governorates/views/governorates_category_view.dart';
import 'package:egy_go/features/guides/views/guides_view.dart';
import 'package:egy_go/features/guides/views/select_guide_screen.dart';
import 'package:egy_go/features/home_search/view/home_search_view.dart';
import 'package:egy_go/features/places/views/places_view.dart';
import 'package:egy_go/features/governorates/views/governorates_view.dart';
import 'package:egy_go/features/splash_and_onboarding/views/on_boarding_view.dart';
import 'package:egy_go/features/splash_and_onboarding/views/splash_view.dart';
import 'package:egy_go/features/trip/data/models/trips_response_model.dart';
import 'package:egy_go/features/trip/views/trip_details_screen.dart';
import 'package:egy_go/features/trip/views/trips_screen.dart';
import 'package:egy_go/features/trip/views/agora_call_screen.dart';
import 'package:egy_go/features/trip/views/end_call_form_screen.dart';
import 'package:egy_go/features/trip/views/payment_success_screen.dart';
import 'package:egy_go/features/trip/views/payment_return_screen.dart';
import 'package:egy_go/features/trip/views/trip_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    case SelectGuideScreen.routeName:
      final tripId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => SelectGuideScreen(tripId: tripId),
        settings: settings,
      );

    case TripDetailsScreen.routeName:
      final tripId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => TripDetailsScreen(tripId: tripId),
        settings: settings,
      );

    case TripsScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const TripsScreen(),
        settings: settings,
      );

    case TripChatScreen.routeName:
      final args = settings.arguments;
      String tripId;
      TripGuide? guide;

      if (args is Map<String, dynamic>) {
        tripId = args['tripId'] as String;
        guide = args['guide'] as TripGuide?;
      } else if (args is String) {
        tripId = args;
        guide = null;
      } else {
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
          settings: settings,
        );
      }

      return MaterialPageRoute(
        builder: (_) => TripChatScreen(tripId: tripId, guide: guide),
        settings: settings,
      );

    case AgoraCallScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => AgoraCallScreen(
          appId: args['appId'] as String,
          channelName: args['channelName'] as String,
          token: args['token'] as String,
          uid: args['uid'] as int,
          callId: args['callId'] as String,
          tripId: args['tripId'] as String,
        ),
        settings: settings,
      );

    case EndCallFormScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => EndCallFormScreen(
          callId: args['callId'] as String,
          tripId: args['tripId'] as String,
        ),
        settings: settings,
      );
    case PaymentSuccessScreen.routeName:
      final tripId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(tripId: tripId),
        settings: settings,
      );
    case PaymentReturnScreen.routeName:
      // Get tripId from parameters or arguments
      String? tripId;

      if (settings.arguments is Map<String, dynamic>) {
        final args = settings.arguments as Map<String, dynamic>;
        tripId = args['tripId'] as String?;
      } else if (settings.arguments is String) {
        tripId = settings.arguments as String;
      }

      // Fallback: try to get from Get parameters
      tripId ??= Get.parameters['tripId'];

      if (tripId == null || tripId.isEmpty) {
        print('[Routes] ❌ PaymentReturnScreen: Missing tripId');
        // Return to home or show error
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
          settings: settings,
        );
      }

      return MaterialPageRoute(
        builder: (_) => PaymentReturnScreen(tripId: tripId!),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const SplashView(),
        settings: settings,
      );
  }
}

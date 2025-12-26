import 'package:egy_go/core/cache/cache_helper.dart';
import 'package:egy_go/core/helper/custom_bloc_observer.dart';
import 'package:egy_go/core/helper/one_generate_routes.dart';
import 'package:egy_go/core/services/deep_link_service.dart';
import 'package:egy_go/core/user/data/repo/user_repo.dart';
import 'package:egy_go/core/user/manager/user_cubit/user_cubit.dart';
import 'package:egy_go/core/utils/app_theme.dart';
import 'package:egy_go/features/governorates/data/repos/governorates_repo/governorates_repo.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_cubit.dart';
import 'package:egy_go/features/places/data/repos/places_repo/places_repo.dart';
import 'package:egy_go/features/places/manager/place_category_cubit/place_category_cubit.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:egy_go/features/splash_and_onboarding/views/splash_view.dart';
import 'package:egy_go/features/trip/views/payment_return_screen.dart';
import 'package:egy_go/features/trip/views/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/helper/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  await CacheHelper.init();
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    _initializeDeepLinking();
  }

  Future<void> _initializeDeepLinking() async {
    print('[MyApp] 🚀 Initializing deep link service...');
    await _deepLinkService.initialize();

    // Listen for deep links
    _deepLinkService.linkStream.listen((uri) {
      print('[MyApp] 🔗 Received deep link: $uri');
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    print('[MyApp] 🔗 Processing deep link: $uri');
    print(
        '[MyApp] 🔗 Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');

    // Parse payment callback
    final paymentCallback = _deepLinkService.parsePaymentCallback(uri);

    if (paymentCallback != null) {
      print('[MyApp] 💳 Payment callback detected');

      // Extract trip ID from query parameters
      String? tripId = paymentCallback.tripId;

      print('[MyApp] 📝 Trip ID: $tripId');
      print('[MyApp] 📝 Session ID: ${paymentCallback.sessionId}');
      print('[MyApp] 📝 Is Success: ${paymentCallback.isSuccess}');
      print('[MyApp] 📝 Is Cancel: ${paymentCallback.isCancel}');

      if (tripId != null && tripId.isNotEmpty) {
        // Wait for app to be ready, then navigate
        Future.delayed(Duration(milliseconds: 800), () {
          if (paymentCallback.isSuccess) {
            // Payment success - navigate to payment return screen
            print('[MyApp] ✅ Navigating to PaymentReturnScreen (success)');

            // Use toNamed instead of offAllNamed to preserve navigation stack
            Get.toNamed(
              PaymentReturnScreen.routeName,
              arguments: tripId,
              preventDuplicates: true,
            );
          } else if (paymentCallback.isCancel) {
            // Payment cancelled - navigate back to trip details
            print('[MyApp] ❌ Navigating to TripDetailsScreen (cancelled)');

            // Navigate to trip details
            Get.toNamed(
              TripDetailsScreen.routeName,
              arguments: tripId,
              preventDuplicates: true,
            );

            // Show cancel message after navigation
            Future.delayed(Duration(milliseconds: 500), () {
              Get.snackbar(
                'Payment Cancelled',
                'You cancelled the payment. You can try again anytime.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.orange.withOpacity(0.9),
                colorText: Colors.white,
                duration: Duration(seconds: 3),
                margin: EdgeInsets.all(16),
              );
            });
          }
        });
      } else {
        print('[MyApp] ⚠️ No trip ID found in payment callback');
        Future.delayed(Duration(milliseconds: 500), () {
          Get.snackbar(
            'Error',
            'Could not process payment callback - missing trip information',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.9),
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.all(16),
          );
        });
      }
    } else {
      print('[MyApp] ⚠️ Not a payment callback, ignoring');
    }
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<GovernoratesCubit>(
              create: (context) => GovernoratesCubit(getIt<GovernoratesRepo>())
                ..fetchGovernorates(),
            ),
            BlocProvider<PlacesCubit>(
              create: (context) =>
                  PlacesCubit(getIt<PlacesRepo>())..fetchPlaces(),
            ),
            BlocProvider<UserCubit>(
              create: (context) => UserCubit(getIt<UserRepo>()),
            ),
            BlocProvider<PlaceCategoryCubit>(
              create: (context) => PlaceCategoryCubit(getIt<PlacesRepo>()),
            ),
            BlocProvider<SelectGuideCubit>(
              create: (context) => SelectGuideCubit(getIt<GuidesRepo>()),
            ),
          ],
          child: GetMaterialApp(
            title: 'EgyGo',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: onGenerateRoutes,
            initialRoute: SplashView.routeName,
            theme: AppTheme.lightTheme,
          ),
        );
      },
    );
  }
}

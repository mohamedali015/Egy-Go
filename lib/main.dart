import 'package:egy_go/core/cache/cache_helper.dart';
import 'package:egy_go/core/helper/custom_bloc_observer.dart';
import 'package:egy_go/core/helper/one_generate_routes.dart';
import 'package:egy_go/core/user/data/repo/user_repo.dart';
import 'package:egy_go/core/user/manager/user_cubit/user_cubit.dart';
import 'package:egy_go/core/utils/app_theme.dart';
import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:egy_go/features/create_trip/manager/create_trip_cubit/create_trip_cubit.dart';
import 'package:egy_go/features/governorates/data/repos/governorates_repo/governorates_repo.dart';
import 'package:egy_go/features/governorates/manager/governorates_cubit/governorates_cubit.dart';
import 'package:egy_go/features/guides/data/repos/guides_repo.dart';
import 'package:egy_go/features/guides/manager/select_guide_cubit/select_guide_cubit.dart';
import 'package:egy_go/features/home/views/home_view.dart';
import 'package:egy_go/features/places/data/repos/places_repo/places_repo.dart';
import 'package:egy_go/features/places/manager/place_category_cubit/place_category_cubit.dart';
import 'package:egy_go/features/places/manager/places_cubit/places_cubit.dart';
import 'package:egy_go/features/splash_and_onboarding/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/helper/get_it.dart';
import 'features/home/views/app_home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  await CacheHelper.init();
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

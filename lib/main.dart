import 'package:egy_go/core/helper/custom_bloc_observer.dart';
import 'package:egy_go/core/helper/one_generate_routes.dart';
import 'package:egy_go/core/utils/app_theme.dart';
import 'package:egy_go/features/auth/views/get_started_view.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:egy_go/features/home/views/home_view.dart';
import 'package:egy_go/features/splash_and_onboarding/views/on_boarding_view.dart';
import 'package:egy_go/features/splash_and_onboarding/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/home/views/app_home_view.dart';

void main() {
  Bloc.observer = CustomBlocObserver();
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
        return MaterialApp(
          title: 'EgyGo',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: onGenerateRoutes,
          initialRoute: AppHomeView.routeName,
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}

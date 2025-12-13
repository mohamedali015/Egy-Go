import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/my_snackbar.dart';
import 'package:egy_go/core/shared_widgets/custom_progress_hud.dart';
import 'package:egy_go/features/auth/data/repo/auth_repo.dart';
import 'package:egy_go/features/auth/manager/login_cubit/login_cubit.dart';
import 'package:egy_go/features/auth/manager/login_cubit/login_state.dart';
import 'package:egy_go/features/auth/views/register_otp_view.dart';
import 'package:egy_go/features/auth/views/widgets/login_widgets/login_view_body.dart';
import 'package:egy_go/features/home/views/app_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/get_it.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = 'LoginView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        getIt<AuthRepo>(),
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                if (state.user.role != 'tourist') {
                  MySnackbar.error(
                      context, "You are not authorized to access this app.");
                } else if (state.user.isEmailVerified != true) {
                  MyNavigator.goTo(screen: RegisterOtpView(), isReplace: true);
                } else {
                  MySnackbar.success(context, 'Login Successful');

                  Navigator.pushNamedAndRemoveUntil(
                      context, AppHomeView.routeName, (route) => false);
                }
              }
              if (state is LoginFailure) {
                MySnackbar.error(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              return CustomProgressHud(
                isLoading: state is LoginLoading ? true : false,
                child: LoginViewBody(),
              );
            },
          ),
        ),
      ),
    );
  }
}

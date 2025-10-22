import 'package:egy_go/core/helper/my_snackbar.dart';
import 'package:egy_go/core/shared_widgets/custom_progress_hud.dart';
import 'package:egy_go/features/auth/manager/login_cubit/login_cubit.dart';
import 'package:egy_go/features/auth/manager/login_cubit/login_state.dart';
import 'package:egy_go/features/auth/views/widgets/login_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = 'LoginView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                MySnackbar.success(context, 'Login Successful');

                // ToDo Navigate to the next screen
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

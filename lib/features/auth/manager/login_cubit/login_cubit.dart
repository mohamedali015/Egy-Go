import 'package:egy_go/features/auth/data/repo/auth_repo.dart';
import 'package:egy_go/features/auth/manager/login_cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repo) : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);
  AuthRepo repo;

  // Removed GlobalKey<FormState> from cubit to avoid duplicate key usage across widgets
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;

  void login() async {
    emit(LoginLoading());
    var result = await repo.login(
      email: emailController.text,
      password: passwordController.text,
    );

    result.fold(
      (error) => emit(LoginFailure(error)),
      (user) => emit(LoginSuccess(user)),
    );
  }

  void changeObsecureText() {
    obsecureText = !obsecureText;
    emit(LoginToggled());
  }
}

import 'package:egy_go/features/auth/manager/login_cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;

  void login() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    emit(LoginLoading());
    // Simulate a login process
    Future.delayed(const Duration(seconds: 2), () {
      emit(LoginSuccess());
    });
  }

  void changeObsecureText() {
    obsecureText = !obsecureText;
    emit(LoginToggled());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reset_password_new_password_state.dart';

class ResetPasswordNewPasswordCubit
    extends Cubit<ResetPasswordNewPasswordState> {
  ResetPasswordNewPasswordCubit() : super(ResetPasswordNewPasswordInitial());

  static ResetPasswordNewPasswordCubit get(context) => BlocProvider.of(context);

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obsecure = true;
  bool confirmObsecure = true;

  void submitNewPassword(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(ResetPasswordNewPasswordLoading());
    // Simulate a network call or any async operation
    Future.delayed(Duration(seconds: 2), () {
      emit(ResetPasswordNewPasswordSuccess());
    });
  }

  void changeObsecurePassword() {
    obsecure = !obsecure;
    emit(ResetPasswordNewPasswordToggled());
  }

  void changeConfirmObsecurePassword() {
    confirmObsecure = !confirmObsecure;
    emit(ResetPasswordNewPasswordToggled());
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}

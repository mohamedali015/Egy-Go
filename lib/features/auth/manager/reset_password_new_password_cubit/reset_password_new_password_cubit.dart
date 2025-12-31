import 'package:egy_go/features/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reset_password_new_password_state.dart';

class ResetPasswordNewPasswordCubit
    extends Cubit<ResetPasswordNewPasswordState> {
  ResetPasswordNewPasswordCubit(this.repo)
      : super(ResetPasswordNewPasswordInitial());

  static ResetPasswordNewPasswordCubit get(context) => BlocProvider.of(context);

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  bool obsecure = true;
  bool confirmObsecure = true;
  AuthRepo repo;

  void submitNewPassword(String email) async {
    if (!passwordFormKey.currentState!.validate()) {
      return;
    }
    emit(ResetPasswordNewPasswordLoading());
    // var result = await repo.resetPassword(
    //   email: email,
    //   password: passwordController.text,
    // );
    //
    // result.fold(
    //   (error) => emit(ResetPasswordNewPasswordFailure(error)),
    //   (message) => emit(ResetPasswordNewPasswordSuccess(message)),
    // );
    await Future.delayed(const Duration(seconds: 2));
    emit(ResetPasswordNewPasswordSuccess("Password reset successfully"));
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

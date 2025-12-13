import 'package:egy_go/features/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.repo) : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  AuthRepo repo;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isChecked = false;
  bool obsecureText = true;
  bool obsecureConfirmPassword = true;

  void register() async {
    if (!isChecked) {
      return emit(RegisterError(error: AppStrings.acceptTerms));
    }

    emit(RegisterLoading());
    var result = await repo.register(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phone: phoneController.text,
    );

    result.fold(
      (error) => emit(RegisterError(error: error)),
      (message) => emit(RegisterSuccess(message: message)),
    );
  }

  void isCheckedChange() {
    isChecked = !isChecked;
    emit(RegisterToggle());
  }

  void passwordVisibilityToggle() {
    obsecureText = !obsecureText;
    emit(RegisterToggle());
  }

  void confirmPasswordVisibilityToggle() {
    obsecureConfirmPassword = !obsecureConfirmPassword;
    emit(RegisterToggle());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isChecked = false;
  bool obsecureText = true;
  bool obsecureConfirmPassword = true;

  void register() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!isChecked) {
      return emit(RegisterError(error: AppStrings.acceptTerms));
    }

    emit(RegisterLoading());
    // Simulate a registration process
    Future.delayed(const Duration(seconds: 2), () {
      emit(RegisterSuccess());
    });
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

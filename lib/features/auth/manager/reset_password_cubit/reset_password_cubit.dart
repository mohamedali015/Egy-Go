import 'package:egy_go/features/auth/manager/reset_password_cubit/reset_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  /// Email Verification
  TextEditingController emailController = TextEditingController();

  void submitEmail() {
    // Validation handled in UI using a local Form key
    emit(ResetPasswordLoading());
    // Simulate a network call or any async operation
    Future.delayed(Duration(seconds: 2), () {
      emit(ResetPasswordSuccess());
    });
  }

  /// OTP Verification
  String otpCode = '';
  bool isOtpComplete = false;

  void onOtpChanged(String otp) {
    otpCode = otp;
    isOtpComplete = otp.length == 4; // Assuming OTP length is 4
    emit(ResetPasswordOtpChanged());
  }

  void resendOtp() {
    emit(ResetPasswordLoading());
    // Logic to resend OTP
    Future.delayed(Duration(seconds: 2), () {
      emit(ResetPasswordToggle());
    });
  }

  void verifyOtp() {
    if (isOtpComplete) {
      emit(ResetPasswordLoading());
      // Logic to verify OTP
      Future.delayed(Duration(seconds: 2), () {
        emit(ResetPasswordSuccess());
      });
    } else {
      emit(ResetPasswordError(error: 'Please enter a valid OTP'));
    }
  }

  /// New Password Submission
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obsecure = true;
  bool confirmObsecure = true;

  void submitNewPassword() {
    // Validation handled in UI using a local Form key
    emit(ResetPasswordLoading());
    // Simulate a network call or any async operation
    Future.delayed(Duration(seconds: 2), () {
      emit(ResetPasswordSuccess());
    });
  }

  void changeObsecurePassword() {
    obsecure = !obsecure;
    emit(ResetPasswordToggle());
  }

  void changeConfirmObsecurePassword() {
    confirmObsecure = !confirmObsecure;
    emit(ResetPasswordToggle());
  }
}

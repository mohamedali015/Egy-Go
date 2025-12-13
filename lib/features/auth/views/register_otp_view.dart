import 'package:egy_go/features/auth/manager/register_otp_cubit/register_otp_cubit.dart';
import 'package:egy_go/features/auth/manager/register_otp_cubit/register_otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared_widgets/custom_progress_hud.dart';
import 'reset_password_new_pass_view.dart';
import 'widgets/reset_password_widgets/otp_widget.dart';

class RegisterOtpView extends StatelessWidget {
  const RegisterOtpView({super.key});

  static const String routeName = 'Register-otp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => RegisterOtpCubit(),
        child: Builder(builder: (context) {
          return BlocConsumer<RegisterOtpCubit, RegisterOtpState>(
            listener: (context, state) {
              if (state is RegisterOtpVerified) {
                Navigator.pushReplacementNamed(
                  context,
                  ResetPasswordNewPassView.routeName,
                );
              }
            },
            builder: (context, state) {
              final cubit = RegisterOtpCubit.get(context);
              return CustomProgressHud(
                isLoading: state is RegisterOtpLoading,
                child: OtpWidget(
                  onOtpChanged: cubit.onOtpChanged,
                  onResendOtp: cubit.resendOtp,
                  onVerifyOtp: cubit.verifyOtp,
                  isOtpComplete: cubit.isOtpComplete,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

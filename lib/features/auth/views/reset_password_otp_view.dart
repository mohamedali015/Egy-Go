import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared_widgets/custom_progress_hud.dart';
import '../manager/reset_password_otp_cubit/reset_password_otp_cubit.dart';
import '../manager/reset_password_otp_cubit/reset_password_otp_state.dart';
import 'reset_password_new_pass_view.dart';
import 'widgets/reset_password_widgets/otp_widget.dart';

class ResetPasswordOtpView extends StatelessWidget {
  const ResetPasswordOtpView({super.key});

  static const String routeName = 'reset-password-otp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ResetPasswordOtpCubit, ResetPasswordOtpState>(
        listener: (context, state) {
          if (state is ResetPasswordOtpVerified) {
            Navigator.pushReplacementNamed(
              context,
              ResetPasswordNewPassView.routeName,
            );
          }
        },
        builder: (context, state) {
          final cubit = ResetPasswordOtpCubit.get(context);
          return CustomProgressHud(
            isLoading: state is ResetPasswordOtpLoading,
            child: OtpWidget(
              onOtpChanged: cubit.onOtpChanged,
              onResendOtp: cubit.resendOtp,
              onVerifyOtp: cubit.verifyOtp,
              isOtpComplete: cubit.isOtpComplete,
            ),
          );
        },
      ),
    );
  }
}

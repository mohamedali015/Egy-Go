import 'package:egy_go/features/auth/manager/reset_password_new_password_cubit/reset_password_new_password_cubit.dart';
import 'package:egy_go/features/auth/manager/reset_password_verify_email_cubit/reset_password_verify_email_cubit.dart';
import 'package:egy_go/features/auth/views/reset_password_new_pass_view.dart';
import 'package:egy_go/features/auth/views/reset_password_otp_view.dart';
import 'package:egy_go/features/auth/views/reset_password_verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/reset_password_otp_cubit/reset_password_otp_cubit.dart';

class ForgetPasswordFlow extends StatelessWidget {
  static const String routeName = 'forgetPasswordFlow';

  const ForgetPasswordFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ResetPasswordVerifyEmailCubit()),
        BlocProvider(create: (_) => ResetPasswordOtpCubit()),
        BlocProvider(create: (_) => ResetPasswordNewPasswordCubit()),
      ],
      child: Navigator(
        initialRoute: ResetPasswordVerifyEmailView.routeName,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ResetPasswordVerifyEmailView.routeName:
              return MaterialPageRoute(
                  builder: (_) => ResetPasswordVerifyEmailView());
            case ResetPasswordOtpView.routeName:
              return MaterialPageRoute(builder: (_) => ResetPasswordOtpView());
            case ResetPasswordNewPassView.routeName:
              return MaterialPageRoute(
                  builder: (_) => ResetPasswordNewPassView());
            default:
              return MaterialPageRoute(
                  builder: (_) => ResetPasswordVerifyEmailView());
          }
        },
      ),
    );
  }
}

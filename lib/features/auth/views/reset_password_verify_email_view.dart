import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/features/auth/views/widgets/reset_password_widgets/reset_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/my_snackbar.dart';
import '../../../core/shared_widgets/custom_progress_hud.dart';
import '../../../core/shared_widgets/custom_text_form_field.dart';
import '../../../core/utils/app_strings.dart';
import '../manager/reset_password_verify_email_cubit/reset_password_verify_email_cubit.dart';
import '../manager/reset_password_verify_email_cubit/reset_password_verify_email_state.dart';
import 'reset_password_otp_view.dart';

class ResetPasswordVerifyEmailView extends StatefulWidget {
  const ResetPasswordVerifyEmailView({super.key});

  static const String routeName = "reset_password";

  @override
  State<ResetPasswordVerifyEmailView> createState() =>
      _ResetPasswordVerifyEmailViewState();
}

class _ResetPasswordVerifyEmailViewState
    extends State<ResetPasswordVerifyEmailView> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ResetPasswordVerifyEmailCubit,
          ResetPasswordVerifyEmailState>(
        listener: (context, state) {
          if (state is ResetPasswordVerifyEmailSuccess) {
            MyNavigator.goTo(
              screen: ResetPasswordOtpView(email: state.email),
            );
          } else if (state is ResetPasswordVerifyEmailFailure) {
            MySnackbar.error(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          final cubit = ResetPasswordVerifyEmailCubit.get(context);
          return CustomProgressHud(
            isLoading: state is ResetPasswordVerifyEmailLoading,
            child: ResetPasswordWidget(
              controller: cubit.emailController,
              subtitle: AppStrings.forgotPasswordSubtitle,
              textFieldType: TextFieldType.email,
              onPressed: () {
                if (!_emailFormKey.currentState!.validate()) return;
                cubit.submitEmail();
              },
              formKey: _emailFormKey,
            ),
          );
        },
      ),
    );
  }
}

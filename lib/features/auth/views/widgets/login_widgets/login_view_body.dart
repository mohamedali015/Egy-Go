import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/shared_widgets/custom_text_form_field.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/auth/manager/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';

import '../../register_view.dart';
import '../do_not_have_account.dart';
import '../reset_password_widgets/forget_password_flow.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = LoginCubit.get(context);
    return Padding(
      padding: MyResponsive.paddingSymmetric(
        horizontal: 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MyResponsive.height(value: 20),
            ),
            Text(
              AppStrings.loginTitle,
              style: AppTextStyles.bold36,
            ),
            SizedBox(
              height: MyResponsive.height(value: 20),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    type: TextFieldType.email,
                    controller: cubit.emailController,
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 22),
                  ),
                  CustomTextFormField(
                    type: TextFieldType.password,
                    controller: cubit.passwordController,
                    onSuffixTapped: cubit.changeObsecureText,
                    obsecure: cubit.obsecureText,
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ForgetPasswordFlow.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.bold13.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 50),
                  ),
                  CustomButton(
                    title: AppStrings.login,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      cubit.login();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyResponsive.height(value: 43),
            ),
            // OrDivider(),
            // SizedBox(
            //   height: MyResponsive.height(value: 41),
            // ),
            // SocialLoginButton(
            //   imagePath: AppAssets.googleLogo,
            //   title: AppStrings.loginWithGoogle,
            //   onPressed: () {},
            // ),
            // SizedBox(
            //   height: MyResponsive.height(value: 16),
            // ),
            // SocialLoginButton(
            //   imagePath: AppAssets.facebookLogo,
            //   title: AppStrings.loginWithFacebook,
            //   onPressed: () {},
            // ),
            // SizedBox(
            //   height: MyResponsive.height(value: 80),
            // ),
            DoNotHaveAccount(
              question: AppStrings.dontHaveAccount,
              actionText: AppStrings.register,
              onPressed: () {
                Navigator.pushReplacementNamed(context, RegisterView.routeName);
              },
            ),
            SizedBox(
              height: MyResponsive.height(value: 50),
            ),
          ],
        ),
      ),
    );
  }
}

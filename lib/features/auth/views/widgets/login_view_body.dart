import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/shared_widgets/custom_text_form_field.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/auth/manager/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = LoginCubit.get(context);
    return Padding(
      padding: MyResponsive.paddingSymmetric(
        horizontal: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MyResponsive.height(value: 42),
          ),
          Text(
            AppStrings.loginTitle,
            style: AppTextStyles.bold36,
          ),
          SizedBox(
            height: MyResponsive.height(value: 45),
          ),
          Form(
            key: cubit.formKey,
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
                Row(
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
                SizedBox(
                  height: MyResponsive.height(value: 50),
                ),
                CustomButton(
                  title: AppStrings.login,
                  onPressed: cubit.login,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

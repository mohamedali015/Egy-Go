import 'package:egy_go/features/auth/manager/register_cubit/register_cubit.dart';
import 'package:egy_go/features/auth/views/login_view.dart';
import 'package:egy_go/features/auth/views/widgets/register_widgets/terms_and_conditions_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/shared_widgets/custom_text_form_field.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../do_not_have_account.dart';

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = RegisterCubit.get(context);
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
              AppStrings.registerTitle,
              style: AppTextStyles.bold36,
            ),
            SizedBox(
              height: MyResponsive.height(value: 20),
            ),
            Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    type: TextFieldType.name,
                    controller: cubit.nameController,
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 16),
                  ),
                  CustomTextFormField(
                    type: TextFieldType.email,
                    controller: cubit.emailController,
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 16),
                  ),
                  CustomTextFormField(
                    type: TextFieldType.phone,
                    controller: cubit.phoneController,
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 16),
                  ),
                  CustomTextFormField(
                    type: TextFieldType.password,
                    controller: cubit.passwordController,
                    onSuffixTapped: cubit.passwordVisibilityToggle,
                    obsecure: cubit.obsecureText,
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 16),
                  ),
                  CustomTextFormField(
                    type: TextFieldType.password,
                    controller: cubit.confirmPasswordController,
                    passController: cubit.passwordController,
                    onSuffixTapped: cubit.confirmPasswordVisibilityToggle,
                    obsecure: cubit.obsecureConfirmPassword,
                  ),
                  SizedBox(
                    height: MyResponsive.height(value: 16),
                  ),
                  TermsAndConditionRow(),
                  SizedBox(
                    height: MyResponsive.height(value: 50),
                  ),
                  CustomButton(
                    title: AppStrings.register,
                    onPressed: cubit.register,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyResponsive.height(value: 43),
            ),
            DoNotHaveAccount(
              question: AppStrings.alreadyHaveAccount,
              actionText: AppStrings.login,
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginView.routeName);
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

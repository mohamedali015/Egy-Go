import 'package:flutter/material.dart';

import '../helper/my_responsive.dart';
import '../helper/validator.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.type,
    this.controller,
    this.passController,
    this.obsecure = true,
    this.onSuffixTapped,
    this.onChanged,
    this.focusNode,
    this.searchHint = AppStrings.searchHint,
  });

  final TextFieldType type;
  final TextEditingController? controller;
  final TextEditingController? passController;
  final bool obsecure;
  final void Function()? onSuffixTapped;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? searchHint;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TextFieldType.password:
        return _passwordField(
          context,
          passController == null
              ? Validator.password
              : (value) =>
                  Validator.confirmPassword(value, passController!.text),
        );

      case TextFieldType.email:
        return _emailField(context, Validator.email);

      case TextFieldType.phone:
        return _phoneField(context, Validator.phone);

      case TextFieldType.name:
        return _nameField(context, Validator.name);

      case TextFieldType.search:
        return _searchField(context);
    }
  }

  ///////////////////////--Decorations//////////////////////
  InputDecoration _inputDecoration(
    BuildContext context, {
    String? label,
    String? hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.bold13.copyWith(color: AppColors.grey),
      hintText: hint,
      hintStyle: AppTextStyles.bold13.copyWith(color: AppColors.grey),
      filled: true,
      fillColor: AppColors.fill,
      // errorMaxLines: 2,
      contentPadding: MyResponsive.paddingSymmetric(
        horizontal: 13,
        vertical: 20,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: _border(context, AppColors.grey),
      focusedErrorBorder: _border(context, AppColors.red),
      focusedBorder: _border(context, AppColors.primary),
      enabledBorder: _border(context, AppColors.grey),
      errorBorder: _border(context, AppColors.red),
    );
  }

  // TextStyle _textStyle(BuildContext context) {
  //   return AppTextStyles.semiBold13;
  // }

  InputBorder _border(BuildContext context, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(MyResponsive.radius(value: 10)),
      ),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  /////////////////////////--TextFields////////////////////////////////
  Widget _nameField(
    BuildContext context,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.primary,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.name,
      decoration: _inputDecoration(
        context,
        label: AppStrings.nameHint,
        prefixIcon: Icon(
          Icons.person_2_outlined,
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _phoneField(
    BuildContext context,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.primary,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration(
        context,
        label: AppStrings.phoneNumber,
        prefixIcon: Icon(
          Icons.local_phone_outlined,
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _emailField(
    BuildContext context,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.primary,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration(
        context,
        label: AppStrings.emailHint,
        prefixIcon: Icon(
          Icons.email_outlined,
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _passwordField(
    BuildContext context,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.primary,
      validator: validator,
      obscureText: obsecure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.visiblePassword,
      decoration: _inputDecoration(
        context,
        label: passController == null
            ? AppStrings.passwordHint
            : AppStrings.confirmPasswordHint,
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.grey),
        suffixIcon: IconButton(
          onPressed: onSuffixTapped,
          icon: obsecure
              ? Icon(
                  Icons.visibility_outlined,
                  color: AppColors.grey,
                )
              : Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.grey,
                ),
        ),
      ),
    );
  }

  Widget _searchField(
    BuildContext context,
  ) {
    return TextField(
      focusNode: focusNode,
      cursorColor: AppColors.primary,
      decoration: _inputDecoration(
        context,
        hint: searchHint,
        suffixIcon: Icon(
          Icons.search,
          color: AppColors.grey,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

enum TextFieldType { password, email, name, phone, search }

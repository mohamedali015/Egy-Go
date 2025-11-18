import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';
import 'custom_otp_field.dart';

class OtpWidget extends StatelessWidget {
  const OtpWidget({
    super.key,
    required this.onOtpChanged,
    required this.onResendOtp,
    required this.onVerifyOtp,
    required this.isOtpComplete,
  });

  final Function(String) onOtpChanged;
  final VoidCallback onResendOtp;
  final VoidCallback onVerifyOtp;
  final bool isOtpComplete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MyResponsive.height(value: 10)),
          Padding(
            padding: MyResponsive.paddingSymmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.otpTitle,
                  style: AppTextStyles.bold25,
                ),
                SizedBox(height: MyResponsive.height(value: 16)),
                Text(
                  AppStrings.otpSubtitle,
                  style:
                      AppTextStyles.regular14.copyWith(color: AppColors.grey),
                ),
                SizedBox(height: MyResponsive.height(value: 27)),
                CustomOtpField(
                  onChanged: onOtpChanged,
                ),
                SizedBox(height: MyResponsive.height(value: 27)),
                Text(
                  AppStrings.doNotReceiveCode,
                  style: AppTextStyles.regular14,
                ),
                SizedBox(height: MyResponsive.height(value: 16)),
                TextButton(
                  onPressed: onResendOtp,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    AppStrings.resendCode,
                    style: AppTextStyles.medium16
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                SizedBox(height: MyResponsive.height(value: 70)),
                CustomButton(
                  title: AppStrings.verify,
                  onPressed: isOtpComplete ? onVerifyOtp : null,
                  backgroundColor: isOtpComplete
                      ? AppColors.primary
                      : AppColors.grey.withValues(alpha: .2),
                ),
                SizedBox(
                  height: MyResponsive.height(value: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

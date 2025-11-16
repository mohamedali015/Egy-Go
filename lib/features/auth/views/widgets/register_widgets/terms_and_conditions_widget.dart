import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/my_responsive.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../manager/register_cubit/register_cubit.dart';

class TermsAndConditionRow extends StatelessWidget {
  const TermsAndConditionRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RegisterCubit cubit = RegisterCubit.get(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.4,
          child: Checkbox(
            value: cubit.isChecked,
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return Colors.transparent;
            }),
            side: BorderSide(
              color: AppColors.grey,
              width: 2,
            ),
            onChanged: (value) {
              cubit.isCheckedChange();
            },
          ),
        ),
        SizedBox(
          width: MyResponsive.width(value: 16),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppStrings.byClicking,
                  style: AppTextStyles.bold13.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                TextSpan(text: "  "),
                TextSpan(
                  text: AppStrings.conditionsAndTerms,
                  style: AppTextStyles.bold13.copyWith(
                    color: AppColors.primary,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
            // textDirection:
            //     Directionality.of(context),
          ),
        ),
      ],
    );
  }
}

import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/create_trip/manager/create_trip_cubit/create_trip_cubit.dart';
import 'package:flutter/material.dart';

import 'create_trip_form_widget.dart';

class CreateTripFormViewBody extends StatelessWidget {
  const CreateTripFormViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingSymmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MyResponsive.height(value: 40),
            ),
            Text(
              AppStrings.formTitle,
              style: AppTextStyles.bold20,
            ),
            SizedBox(
              width: double.infinity,
              height: MyResponsive.height(value: 12),
            ),
            Text(
              AppStrings.formSubtitle,
              style: AppTextStyles.semiBold12,
            ),
            SizedBox(
              height: MyResponsive.height(value: 40),
            ),
            CreateTripFormWidget(),
            SizedBox(
              height: MyResponsive.height(value: 30),
            ),
            CustomButton(
              title: AppStrings.findGuide,
              onPressed: CreateTripCubit.get(context).submit,
            ),
            SizedBox(
              height: MyResponsive.height(value: 20),
            ),
          ],
        ),
      ),
    );
  }
}

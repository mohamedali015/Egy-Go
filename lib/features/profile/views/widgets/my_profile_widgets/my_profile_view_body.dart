import 'package:egy_go/core/helper/my_navigator.dart';
import 'package:egy_go/core/helper/my_responsive.dart';
import 'package:egy_go/core/helper/my_snackbar.dart';
import 'package:egy_go/core/shared_widgets/custom_button.dart';
import 'package:egy_go/core/shared_widgets/custom_text_form_field.dart';
import 'package:egy_go/core/user/manager/user_cubit/user_cubit.dart';
import 'package:egy_go/core/user/manager/user_cubit/user_state.dart';
import 'package:egy_go/core/utils/app_colors.dart';
import 'package:egy_go/core/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'showing_dialog_widget.dart';

class MyProfileViewBody extends StatelessWidget {
  const MyProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var userCubit = UserCubit.get(context);
    return Form(
        key: userCubit.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: MyResponsive.paddingSymmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(height: MyResponsive.height(value: 25)),
                // CircleAvatar(
                //   radius: MyResponsive.width(value: 50),
                //   backgroundColor: Colors.transparent,
                //   child: ImageManagerView(
                //     onPicked: (XFile imageFile) {
                //       userCubit.imageFile = imageFile;
                //     },
                //     pickedBody: (XFile imageFile) {
                //       return ProfileImageWidget(
                //         imagePath: imageFile.path,
                //         isLocalFile: true,
                //         width: MyResponsive.width(value: 100),
                //       );
                //     },
                //     unPickedBody: ProfileImageWidget(
                //         imagePath: userCubit.userModel.imagePath,
                //         width: MyResponsive.width(value: 100)),
                //   ),
                // ),
                SizedBox(height: MyResponsive.height(value: 66)),
                CustomTextFormField(
                    type: TextFieldType.name,
                    controller: userCubit.nameController),
                SizedBox(height: MyResponsive.height(value: 10)),
                CustomTextFormField(
                    type: TextFieldType.phone,
                    controller: userCubit.phoneController),
                SizedBox(height: MyResponsive.height(value: 75)),
                BlocListener<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state is UserDeleteSuccess) {
                      MySnackbar.success(context, state.message);
                    } else if (state is UserUpdateSuccess) {
                      MySnackbar.success(context, state.message);
                      MyNavigator.pop();
                    } else if (state is UserUpdateError) {
                      MySnackbar.error(context, state.error);
                    } else if (state is UserDeleteError) {
                      MySnackbar.error(context, state.error);
                    }
                  },
                  child: CustomButton(
                    title: AppStrings.save,
                    // onPressed: userCubit.updateUserData,
                    foregroundColor: AppColors.white,
                  ),
                ),
                SizedBox(height: MyResponsive.height(value: 300)),
                CustomButton(
                  title: AppStrings.deleteAccount,
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => const ShowingDialogWidget(),
                    );
                  },
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ));
  }
}

import 'package:egy_go/core/utils/app_strings.dart';
import 'package:egy_go/features/profile/views/widgets/my_profile_widgets/my_profile_view_body.dart';
import 'package:flutter/material.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.myProfile),
        centerTitle: true,
      ),
      body: MyProfileViewBody(),
    );
  }
}

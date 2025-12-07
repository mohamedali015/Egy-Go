import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'widgets/governorates_category_widgets/governorates_category_view_body.dart';

class GovernoratesCategoryView extends StatelessWidget {
  const GovernoratesCategoryView({super.key});

  static const String routeName = 'governoratesCategoryView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Giza",
          style: AppTextStyles.semiBold28.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: GovernoratesCategoryViewBody(),
    );
  }
}

import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:egy_go/features/guides/views/widgets/guides_view_body.dart';
import 'package:flutter/material.dart';

class GuidesView extends StatelessWidget {
  const GuidesView({super.key});

  static const String routeName = "guides";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guides',
          style: AppTextStyles.semiBold20,
        ),
        centerTitle: true,
      ),
      body: GuidesViewBody(),
    );
  }
}

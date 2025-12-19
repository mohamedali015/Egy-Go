import 'package:egy_go/core/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';

class ShowingDialogWidget extends StatelessWidget {
  const ShowingDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(AppStrings.deleteAccount),
      content: Text(AppStrings.deleteAccountMessage),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppStrings.cancel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            // Implement your logout logic here
            // UserCubit.get(context).deleteUserAccount();
          },
          child: Text(AppStrings.deleteAccount),
        ),
      ],
    );
  }
}

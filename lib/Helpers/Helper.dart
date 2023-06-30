import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Helper {
  static Future showDialogAwesome({
    BuildContext context,
    bool status = true,
    String title,
    String desc,
    Function onChanged,
    String btnOkText,
  }) async {
    return AwesomeDialog(
      context: context,
      dialogType: status ? DialogType.SUCCES : DialogType.ERROR,
      headerAnimationLoop: true,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      btnOkOnPress: onChanged,
      btnOkText: btnOkText,
    )..show();
  }
}

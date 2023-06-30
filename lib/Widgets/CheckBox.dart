import 'package:flutter/material.dart';
import 'package:student_app/Helpers/Const.dart' show CColors;

class CheckBox extends StatelessWidget {
  const CheckBox({
    Key key,
    @required this.onTap,
    @required this.value,
    this.iconSize = 15.0,
  }) : super(key: key);
  final Function onTap;
  final bool value;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? CColors.primaryTheme : null,
          border: !value ? Border.all(color: CColors.secondaryTheme) : null,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.check,
          size: iconSize,
          color: !value ? CColors.primaryTheme : CColors.whiteTheme,
        ),
      ),
    );
  }
}

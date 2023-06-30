import 'package:flutter/material.dart';
import 'package:student_app/Helpers/Const.dart';

class ButtomWithRadius extends StatelessWidget {
  const ButtomWithRadius({
    Key key,
    @required this.text,
    @required this.functionOnTab,
    this.style,
  }) : super(key: key);

  final String text;
  final Function functionOnTab;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              CColors.primaryTheme,
              CColors.secondaryTheme,
            ],
          ),
        ),
        child: InkWell(
          onTap: functionOnTab,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ).merge(style),
            ),
          ),
        ),
      ),
    );
  }
}

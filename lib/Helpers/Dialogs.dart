import 'package:flutter/material.dart';
import 'package:student_app/Helpers/Const.dart';
import 'package:student_app/Helpers/Validation.dart';
import 'package:student_app/Widgets/ButtomWithRadius.dart';
import 'package:student_app/Widgets/InputField.dart';

class DialogAddClass extends StatelessWidget {
  const DialogAddClass({
    Key key,
    @required this.formKey,
    @required this.controller,
    @required this.functionOnTab,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Function functionOnTab;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add class'),
              InputField(
                keyboardType: TextInputType.name,
                controller: controller,
                validator: (value) => Validation.validationRequired(
                  value,
                  'Please enter your name class',
                ),
                prefix: Icon(
                  Icons.home,
                  color: CColors.primaryTheme,
                  size: 18.0,
                ),
              ),
              ButtomWithRadius(
                functionOnTab: functionOnTab,
                text: 'Add class',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogAddStudent extends StatelessWidget {
  const DialogAddStudent({
    Key key,
    @required this.controller,
    @required this.functionOnTab,
    @required this.formKey,
  }) : super(key: key);

  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final Function functionOnTab;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Student'),
              InputField(
                keyboardType: TextInputType.name,
                controller: controller,
                validator: (value) => Validation.validationRequired(
                  value,
                  'Please enter your Student name',
                ),
                prefix: Icon(
                  Icons.home,
                  color: CColors.primaryTheme,
                  size: 18.0,
                ),
              ),
              ButtomWithRadius(
                functionOnTab: functionOnTab,
                text: 'Add Student',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

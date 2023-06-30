import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_app/Helpers/Const.dart' show CColors;
import 'dart:ui' as ui;

class InputField extends StatelessWidget {
  InputField({
    this.labelText,
    this.obscureText = false,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.controller,
    this.suffixText,
    this.suffixIcon,
    this.prefix,
    this.enabled = true,
    this.inputFormatters,
    this.validator,
  });
  final String labelText, suffixText;
  final Widget suffixIcon, prefix;
  final int maxLength, minLines, maxLines;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscureText, enabled;
  final List<TextInputFormatter> inputFormatters;
  final Function validator;

  TextAlign get textAlign {
    TextAlign textAlign;
    if (keyboardType == TextInputType.phone) {
      textAlign = TextAlign.left;
    } else {
      textAlign = TextAlign.start;
    }
    return textAlign;
  }

  ui.TextDirection get _textDirection {
    ui.TextDirection textAlign;
    if (keyboardType == TextInputType.phone) {
      textAlign = ui.TextDirection.rtl;
    } else {
      textAlign = ui.TextDirection.ltr;
    }
    return textAlign;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _textDirection,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (labelText != null && labelText.isNotEmpty) ...[
              Text(
                labelText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 8.0),
            ],
            TextFormField(
              validator: validator,
              enabled: enabled,
              cursorColor: CColors.primaryTheme,
              controller: controller,
              obscureText: obscureText,
              style: TextStyle(color: CColors.primaryTheme),
              maxLength: maxLength,
              maxLines: maxLines,
              minLines: minLines,
              textAlign: textAlign,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8E8E8E)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0xFF8E8E8E)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0xFF8E8E8E)),
                ),
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.all(13.0),
                suffixText: suffixText,
                suffixIcon: suffixIcon,
                prefixIcon: prefix,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

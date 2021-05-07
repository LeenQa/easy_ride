import 'package:easy_ride/Screens/Signup/components/field_validation.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/components/text_field_container.dart';
import 'package:easy_ride/constants.dart';

class RoundedInputField extends StatelessWidget {
  final double margin;
  final int maxLines;
  final bool autofocus;
  final double radius;
  final Color color;
  final String hintText;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final InputDecoration inputDecoration;
  final IconData icon;
  final ValueChanged<String> onSaved;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const RoundedInputField(
      {Key key,
      this.hintText,
      this.icon,
      this.onSaved,
      this.keyboardType,
      this.controller,
      this.onChanged,
      this.margin,
      this.radius,
      this.maxLines,
      this.textAlign,
      this.inputDecoration,
      this.autofocus,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color == null ? null : color,
      margin: margin,
      radius: radius,
      child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Fill empty fields";
            } else if (hintText == "Username") {
              return FieldValidation.validateUsername(value, context);
            } else if (hintText == getTranslated(context, 'email')) {
              return FieldValidation.validateEmail(value, context);
            } else if (hintText == getTranslated(context, 'phone')) {
              if (value.length < 7) {
                return "Phone number is too short";
              }
              if (value.length > 15) {
                return "Phone number is too long";
              }
            } else if (value.length < 3) {
              return "Enter at least 3 characters";
            } else
              return null;
          },
          onSaved: onSaved,
          onChanged: onChanged,
          maxLines: maxLines,
          controller: controller,
          cursorColor: kPrimaryColor,
          keyboardType: keyboardType,
          autofocus: autofocus == null ? false : autofocus,
          textAlign: textAlign == null ? TextAlign.start : textAlign,
          decoration: inputDecoration == null
              ? InputDecoration(
                  icon: Icon(
                    icon,
                    color: kPrimaryColor,
                  ),
                  hintText: hintText,
                  border: InputBorder.none,
                )
              : inputDecoration),
    );
  }
}

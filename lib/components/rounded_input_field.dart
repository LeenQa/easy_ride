import 'package:easy_ride/Screens/Signup/components/field_validation.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/components/text_field_container.dart';
import 'package:easy_ride/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final IconData icon;
  final ValueChanged<String> onSaved;
  const RoundedInputField(
      {Key key, this.hintText, this.icon, this.onSaved, this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (value) {
          if (hintText == "Username") {
            return FieldValidation.validateUsername(value, context);
          } else if (value.isEmpty) {
            return "Fill empty fields";
          } else
            return null;
        },
        onSaved: onSaved,
        cursorColor: kPrimaryColor,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

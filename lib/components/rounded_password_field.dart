import 'package:flutter/material.dart';
import 'package:easy_ride/components/text_field_container.dart';
import 'package:easy_ride/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onSaved;
  final String hintText;
  final Function(String) validator;
  const RoundedPasswordField({
    Key key,
    this.onSaved,
    this.validator,
    this.hintText,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool obsc = true;
  void _changeObsc() {
    setState(() {
      print(obsc);
      obsc = !obsc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: this.widget.validator,
        obscureText: obsc,
        onSaved: widget.onSaved,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          errorMaxLines: 3,
          hintText: this.widget.hintText,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: _changeObsc,
            child: Icon(
              Icons.visibility,
              color: kPrimaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

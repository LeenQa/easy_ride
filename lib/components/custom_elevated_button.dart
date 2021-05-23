import 'package:easy_ride/constants.dart';
import 'package:flutter/material.dart';
import 'main_drawer.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final String title;
  final Color backgroundColor;
  final Color borderColor;

  const CustomElevatedButton(
      {Key key,
      this.color,
      this.onPressed,
      this.title,
      this.backgroundColor,
      this.borderColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: getTitle(
          title: title,
          color: color == null ? Colors.white : color,
          fontSize: 14),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: borderColor != null
              ? BorderSide(
                  width: 2.0,
                  color: borderColor,
                )
              : BorderSide(
                  width: 0,
                  color: backgroundColor != null
                      ? backgroundColor
                      : kPrimaryColor),
        )),
        elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
          return 5; // Use the component's default.
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return kPrimaryLightColor;
            else
              return backgroundColor == null
                  ? kPrimaryColor
                  : backgroundColor; // Use the component's default.
          },
        ),
      ),
    );
  }
}

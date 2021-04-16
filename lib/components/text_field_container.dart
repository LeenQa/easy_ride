import 'package:flutter/material.dart';
import 'package:easy_ride/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double margin;
  final double radius;
  const TextFieldContainer({
    Key key,
    this.child,
    this.margin,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
          left: 10, top: 10, right: 10, bottom: margin == null ? 10 : margin),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(29),
            topRight: Radius.circular(29),
            bottomLeft:
                radius == null ? Radius.circular(29) : Radius.circular(radius),
            bottomRight:
                radius == null ? Radius.circular(29) : Radius.circular(radius)),
      ),
      child: child,
    );
  }
}

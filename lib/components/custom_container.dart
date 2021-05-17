import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Color boxShadowColor;
  final EdgeInsetsGeometry padding;

  const CustomContainer({
    Key key,
    this.child,
    this.boxShadowColor,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            //color: kCardColor,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            //border: Border.all(color: kAccentColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor == null
                    ? Colors.grey.withOpacity(0.2)
                    : boxShadowColor,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          padding: padding == null ? const EdgeInsets.all(10.0) : padding,
          child: child,
        ),
      ],
    );
  }
}

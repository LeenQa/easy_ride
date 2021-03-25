import 'package:flutter/material.dart';

import '../constants.dart';

class InfoContainer extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  const InfoContainer({Key key, this.colors, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          margin: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                color: Colors.grey[300],
                spreadRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: colors != null
                  ? colors
                  : [
                      kPrimaryColor,
                      redColor,
                    ],
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

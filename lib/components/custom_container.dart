import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double height;

  const CustomContainer({Key key, this.child, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cHeight = height != null ? height : 0.32;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        //color: kCardColor,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        //border: Border.all(color: kAccentColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: MediaQuery.of(context).size.height * cHeight,
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}

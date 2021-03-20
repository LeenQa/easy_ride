import 'package:easy_ride/constants.dart';
import 'package:flutter/material.dart';

class OpaqueImage extends StatelessWidget {
  final imageUrl;

  const OpaqueImage({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: NetworkImage(imageUrl),
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.fill,
        ),
        Container(
          color: kPrimaryLightColor.withOpacity(0.85),
        ),
      ],
    );
  }
}

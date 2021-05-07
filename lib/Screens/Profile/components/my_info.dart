import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constants.dart';

class MyInfo extends StatelessWidget {
  final String name;
  final String urlAvatar;
  final String id;
  double sizedBoxSize = 10;
  final bool isDriver;
  //if not driver change it to 20

  final ifDriverS = 20;

  MyInfo(this.name, this.urlAvatar, this.id, this.isDriver);

  //final Size size = Size.fromWidth(120);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: kPrimaryColor,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(urlAvatar),
                  fit: BoxFit.fitWidth,
                )),
          ),
          SizedBox(
            height: sizedBoxSize,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: blackNameTextStyle,
              ),
            ],
          ),
          //if driver display this
          SizedBox(
            height: 10,
          ),
          isDriver
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: Colors.blue,
                      size: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        getTranslated(context, 'verifieddriver'),
                        style: blueSubHeadingTextStyle,
                      ),
                    )
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}

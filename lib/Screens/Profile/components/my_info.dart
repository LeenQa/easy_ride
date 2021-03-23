import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constants.dart';

class MyInfo extends StatelessWidget {
  double sizedBoxSize = 10;
  //if not driver change it to 20

  final ifDriverS = 20;

  //final Size size = Size.fromWidth(120);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: kPrimaryColor,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://media-exp1.licdn.com/dms/image/C4E03AQFjmnD212CQdw/profile-displayphoto-shrink_800_800/0/1605559690753?e=1621468800&v=beta&t=xtjlN_sPq-5CEydr3i6S4SM5r7teBBH9uUhTkywHkik'),
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
                'Alex Dukmak',
                style: blackNameTextStyle,
              ),
            ],
          ),
          //if driver display this
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_rounded,
                color: Colors.blue,
                size: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  getTranslated(context, 'verifieddriver'),
                  style: blueSubHeadingTextStyle,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

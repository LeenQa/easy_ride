import 'package:easy_ride/localization/language_constants.dart';
import 'components/my_info.dart';
import 'components/opaque_image.dart';
import 'components/profile_info_big_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/constants.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'profile')),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    OpaqueImage(
                      //make dynamic
                      imageUrl:
                          'https://media-exp1.licdn.com/dms/image/C4E03AQFjmnD212CQdw/profile-displayphoto-shrink_800_800/0/1605559690753?e=1621468800&v=beta&t=xtjlN_sPq-5CEydr3i6S4SM5r7teBBH9uUhTkywHkik',
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            MyInfo(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    color: Colors.white,
                    child: Column(
                      children: [
                        ProfileInfoBigCard(
                          firstText: "13",
                          secondText: "New matches",
                          icon: Icon(
                            Icons.star,
                            size: 32,
                            color: blueColor,
                          ),
                        ),
                        ProfileInfoBigCard(
                          firstText: "21",
                          secondText: "Unmatched me",
                          /* icon: Image.asset(
                                "assets/icons/sad_smiley.png",
                                width: 32,
                                color: blueColor,
                              ), */
                        ),
                        ProfileInfoBigCard(
                          firstText: "264",
                          secondText: "All matches",
                          /* icon: Image.asset(
                                "assets/icons/checklist.png",
                                width: 32,
                                color: blueColor,
                              ), */
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

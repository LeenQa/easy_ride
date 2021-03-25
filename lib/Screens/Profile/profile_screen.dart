import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import '../../text_style.dart';
import 'components/my_info.dart';
import 'components/opaque_image.dart';
import 'components/profile_info_big_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/constants.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: getTitle(
            title: getTranslated(context, 'profile'),
            color: kPrimaryColor,
            fontSize: 20),
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
                    padding: EdgeInsets.only(bottom: 10, top: 6),
                    child: Column(
                      children: [
                        // TextButton.icon(
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         MaterialStateProperty.resolveWith<Color>(
                        //       (Set<MaterialState> states) {
                        //         return Colors.white;
                        //       },
                        //     ),
                        //     shape: MaterialStateProperty.all<
                        //         RoundedRectangleBorder>(
                        //       RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(18.0),
                        //         side: BorderSide(color: blueColor),
                        //       ),
                        //     ),
                        //   ),
                        //   icon: Icon(
                        //     Icons.message_rounded,
                        //   ),
                        //   label: Text(getTranslated(context, 'sendmessage'),
                        //       style: blueSubHeadingTextStyle),
                        //   onPressed: () {},
                        // ),
                        // Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                          ),
                          title: Text(
                            'Beit Jala, Bethlehem',
                            style: blackTextStyle,
                          ),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 10)),
                            Icon(
                              Icons.rate_review,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.08,
                            ),
                            Title(
                              color: Colors.pink,
                              child: Text(
                                getTranslated(context, 'rating'),
                                style: blackTextStyle,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            SmoothStarRating(
                              rating: 3.5,
                              isReadOnly: true,
                              size: 25,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              starCount: 5,
                              //allowHalfRating: true,
                              spacing: 1.0,
                              onRated: (value) {
                                print("rating value -> $value");
                              },
                            ),
                          ],
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        /* ProfileInfoBigCard(
                            firstText: "13",
                            secondText: "New matches",
                            icon: Icon(
                              Icons.star,
                              size: 32,
                              color: blueColor,
                            ),
                          ), */
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  elevation: 4,
                  backgroundColor: kPrimaryColor,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

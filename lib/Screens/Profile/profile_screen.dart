import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Profile_Pic_Screen/profile_pic_screen.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../text_style.dart';
import 'components/my_info.dart';
import 'components/opaque_image.dart';
import 'components/profile_info_big_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/constants.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String _urlAvatar;
  String _name;
  String _uid;
  getUser() async {
    final User user = auth.currentUser;
    _uid = user.uid;
    var data =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    _urlAvatar = data.data()['urlAvatar'];
    print("noooor kidddd $_urlAvatar");
    _name = data.data()['firstName'] + " " + data.data()['lastName'];
  }

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
                    // OpaqueImage(
                    //   //make dynamic
                    //   imageUrl: _urlAvatar,
                    // ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            MyInfo(_name, _urlAvatar),
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
                  onPressed: () {
                    Navigator.pushNamed(context, ProfilePicScreen.routeName,
                        arguments: _uid);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

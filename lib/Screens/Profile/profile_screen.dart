import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Messages/page/chat_page.dart';
import 'package:easy_ride/Screens/Edit_Profile_Screen/edit_profile_screen.dart';
import 'package:easy_ride/Screens/Profile/components/user_review.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
    getUser();
    super.initState();
  }

  // putnotifications() async {
  //   var docs = await FirebaseFirestore.instance.collection("users").get();
  //   docs.docs.forEach((element) async {
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(element.id)
  //         .update({
  //       "getChatNotifications": true,
  //       "getReminderNotifications": true,
  //       "getRequestNotifications": true,
  //       "showPhone": true,
  //     });
  //   });
  // }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  String currentUser;

  getUser() async {
    Map args = ModalRoute.of(context).settings.arguments;
    final User user = auth.currentUser;
    currentUser = user.uid;
    uid = args['id'] == null ? user.uid : args['id'];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    Map args = ModalRoute.of(context).settings.arguments;

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
                flex: 3,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: MyInfo(args['name'], args['urlAvatar'], args['id'],
                        args['isDriver']),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10, top: 6),
                    child: Column(
                      children: [
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
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(args['id'])
                              .collection('reviews')
                              //.orderBy("dateTime", descending: true)
                              .get(),
                          builder: (BuildContext context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Text('Something Went Wrong Try later');
                                } else {
                                  final reviews = snapshot.data.docs;
                                  double numofRatings =
                                      reviews.length.toDouble();
                                  double sumRatings = 0;
                                  for (int i = 0; i < reviews.length; i++) {
                                    sumRatings += reviews[i].data()["rating"];
                                  }

                                  if (reviews.isEmpty) {
                                    return Container();
                                  } else
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 25,
                                                    horizontal: 10)),
                                            Icon(
                                              Icons.star_rate,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                            ),
                                            Title(
                                              color: Colors.pink,
                                              child: Text(
                                                getTranslated(
                                                    context, 'rating'),
                                                style: blackTextStyle,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                            SmoothStarRating(
                                              rating: sumRatings / numofRatings,
                                              isReadOnly: true,
                                              size: 25,
                                              filledIconData: Icons.star,
                                              halfFilledIconData:
                                                  Icons.star_half,
                                              defaultIconData:
                                                  Icons.star_border,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 25,
                                                    horizontal: 10)),
                                            Icon(
                                              Icons.comment,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                            ),
                                            Title(
                                              color: Colors.pink,
                                              child: Text(
                                                'Reviews',
                                                style: blackTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                            shrinkWrap: true,
                                            itemCount: reviews.length,
                                            itemBuilder: (ctx, index) {
                                              final review = reviews[index];
                                              return UserReview(
                                                date: DateFormat('EEE, MMM d y')
                                                    .format(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            review
                                                                .data()[
                                                                    "dateTime"]
                                                                .microsecondsSinceEpoch))
                                                    .toString(),
                                                review: review.data()["review"],
                                                reviewerId:
                                                    review.data()["reviewerId"],
                                              );
                                            })
                                      ],
                                    );
                                }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: args["isMe"] == true
                    ? FloatingActionButton(
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        elevation: 4,
                        backgroundColor: kPrimaryColor,
                        onPressed: () {
                          final auth = FirebaseAuth.instance.currentUser.uid;
                          Navigator.pushNamed(
                            context,
                            ProfilePicScreen.routeName,
                            arguments: {
                              'id': auth,
                            },
                          );
                        },
                      )
                    : FloatingActionButton(
                        child: Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        elevation: 4,
                        backgroundColor: kPrimaryColor,
                        onPressed: () async {
                          Map args = ModalRoute.of(context).settings.arguments;
                          final auth = FirebaseAuth.instance.currentUser.uid;
                          String convId = null;
                          String chatUser = "";
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(auth)
                              .collection("conversations")
                              .get()
                              .then((value) async {
                            value.docs.asMap().forEach((key, value) {
                              print(value.data()["receiverId"]);
                              if (value.data()["receiverId"] == args['id']) {
                                convId = value.id;
                              }
                            });
                            if (convId != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  convId: convId,
                                  name: args['name'],
                                  urlAvatar: args['urlAvatar'],
                                  chatUser: args['id'],
                                ),
                              ));
                            } else {
                              String path = await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(auth)
                                  .collection("conversations")
                                  .doc()
                                  .id;
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(auth)
                                  .collection("conversations")
                                  .doc(path)
                                  .set({
                                'lastMessageTime': DateTime.now(),
                                'receiverId': args['id']
                              }).then((value) async {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(args['id'])
                                    .collection("conversations")
                                    .doc(path)
                                    .set({
                                  'lastMessageTime': DateTime.now(),
                                  'receiverId': auth
                                }).then((value) async {
                                  await FirebaseFirestore.instance
                                      .collection("conversationmsgs")
                                      .doc(path)
                                      .collection("messages")
                                      .doc()
                                      .id;
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      convId: path,
                                      name: args['name'],
                                      urlAvatar: args['urlAvatar'],
                                      chatUser: args['id'],
                                    ),
                                  ));
                                });
                              });
                            }
                          });
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

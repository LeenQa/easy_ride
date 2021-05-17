import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Messages/page/chat_page.dart';
import 'package:easy_ride/Screens/Edit_Profile_Screen/edit_profile_screen.dart';
import 'package:easy_ride/Screens/Profile/components/user_review.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
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

  String report;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();

  _trySubmit(BuildContext ctx, String reporterId, String reportedId) async {
    final isValid = _formKey.currentState.validate();
    final User user = auth.currentUser;
    var currentUser1 = user.uid;
    Map args = ModalRoute.of(context).settings.arguments;
    FocusScope.of(ctx).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      await FirebaseFirestore.instance.collection("reports").doc().set({
        "report": report,
        "dateTime": DateTime.now(),
        "reporterId": currentUser1,
        "reportedId": args['id']
      });
      _textFieldController.clear();
      await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Confirmation'),
                content: Text('Your report has been submitted.'),
                actions: [
                  new TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: new Text('ok'),
                  ),
                ],
              ));
      Navigator.pop(context);
    }
  }

  void _handleClick(
      BuildContext context, String reporterId, String reportedId) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Form(
            key: _formKey,
            child: new Container(
              height: 350.0,
              color:
                  Color(0xFF737373), //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: redColor,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            getTitle(title: "Report this user", fontSize: 14),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: RoundedInputField(
                                controller: _textFieldController,
                                color: Colors.white,
                                maxLines: 4,
                                textAlign: TextAlign.start,
                                inputDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Write the reason for reporting..',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                onSaved: (value) {
                                  report = value.trim();
                                },
                                autofocus: false,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            CustomElevatedButton(
                              title: "Submit",
                              backgroundColor: redColor,
                              color: Colors.white,
                              onPressed: () =>
                                  _trySubmit(context, reporterId, reportedId),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
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
          actions: !args["isMe"]
              ? <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (String choice) {
                      _handleClick(context, currentUser, uid);
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Report'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ]
              : []),
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
                        Card(
                          elevation: 0,
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(args['id'])
                                .get(),
                            builder: (BuildContext context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                default:
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return Text(
                                        'Something Went Wrong Try later');
                                  } else {
                                    return snapshot.data.data()["showPhone"]
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 25,
                                                      horizontal: 10)),
                                              Icon(
                                                Icons.phone,
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
                                                  "Phone",
                                                  style: blackTextStyle,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                              ),
                                              getTitle(
                                                  title: snapshot.data
                                                      .data()["phone"]),
                                            ],
                                          )
                                        : Container();
                                  }
                              }
                            },
                          ),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        args["isDriver"]
                            ? FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('drivers')
                                    .doc(args['id'])
                                    .collection('reviews')
                                    .orderBy("dateTime", descending: true)
                                    .get(),
                                builder: (BuildContext context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator());
                                    default:
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return Text(
                                            'Something Went Wrong Try later');
                                      } else {
                                        final reviews = snapshot.data.docs;
                                        double numofRatings =
                                            reviews.length.toDouble();
                                        double sumRatings = 0;
                                        for (int i = 0;
                                            i < reviews.length;
                                            i++) {
                                          sumRatings +=
                                              reviews[i].data()["rating"];
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 25,
                                                              horizontal: 10)),
                                                  Icon(
                                                    Icons.star_rate,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  SmoothStarRating(
                                                    rating: sumRatings /
                                                        numofRatings,
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
                                                      print(
                                                          "rating value -> $value");
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 25,
                                                              horizontal: 10)),
                                                  Icon(
                                                    Icons.comment,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
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
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return Divider();
                                                  },
                                                  shrinkWrap: true,
                                                  itemCount: reviews.length,
                                                  itemBuilder: (ctx, index) {
                                                    final review =
                                                        reviews[index];
                                                    return UserReview(
                                                      date: DateFormat(
                                                              'EEE, MMM d y')
                                                          .format(DateTime
                                                              .fromMicrosecondsSinceEpoch(review
                                                                  .data()[
                                                                      "dateTime"]
                                                                  .microsecondsSinceEpoch))
                                                          .toString(),
                                                      review: review
                                                          .data()["review"],
                                                      reviewerId: review
                                                          .data()["reviewerId"],
                                                    );
                                                  })
                                            ],
                                          );
                                      }
                                  }
                                },
                              )
                            : Container()
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

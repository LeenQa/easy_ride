import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Driver_Rides/driver_rides.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart' as User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../text_style.dart';

class RideRequests extends StatefulWidget {
  final List<SearchedRide> rideRequests;
  final List<User.User> users;
  final Ride driverRide;
  RideRequests(this.rideRequests, this.users, this.driverRide);
  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  double rating;
  String review;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();

  _trySubmit(BuildContext ctx, String reviewdId) async {
    print(rating);
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(reviewdId)
          .collection("reviews")
          .doc()
          .set({
        "rating": rating,
        "review": review,
        "dateTime": DateTime.now(),
        "reviewerId": uid
      });
      _textFieldController.clear();
    }
  }

  void _modalBottomSheetMenu(String reviewedId) {
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
                            getTitle(title: "Write a Review", fontSize: 14),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Title(
                                  color: Colors.pink,
                                  child: getTitle(
                                      title: getTranslated(context, 'rating'),
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                SmoothStarRating(
                                  size: 25,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  defaultIconData: Icons.star_border,
                                  starCount: 5,
                                  //allowHalfRating: true,
                                  spacing: 1.0,
                                  onRated: (value) {
                                    rating = value;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: RoundedInputField(
                                  controller: _textFieldController,
                                  color: Colors.white,
                                  maxLines: 4,
                                  textAlign: TextAlign.start,
                                  inputDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Write your review here..',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onSaved: (value) {
                                    review = value.trim();
                                  },
                                  autofocus: false,
                                )),
                            SizedBox(
                              height: 12,
                            ),
                            CustomElevatedButton(
                              title: "Post",
                              backgroundColor: redColor,
                              color: Colors.white,
                              onPressed: () => _trySubmit(context, reviewedId),
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

  khara() {
    ;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  bool already;
  getUser() {
    uid = auth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.driverRide.numOfPassengers);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ride Requests"),
          backgroundColor: Colors.white,
        ),
        body: widget.rideRequests.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "No requests yet!",
                    style: blueSubHeadingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10.0),
                        itemCount: widget.rideRequests.length,
                        itemBuilder: (context, index) {
                          bool isBefore = DateFormat("EEE, MMM d")
                              .parse(widget.rideRequests[index].date)
                              .isBefore(DateTime.now());
                          return GestureDetector(
                            onTap: () async {
                              var driver = await FirebaseFirestore.instance
                                  .collection("drivers")
                                  .doc(widget.rideRequests[index].currentUser)
                                  .get();

                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: {
                                    'id':
                                        widget.rideRequests[index].currentUser,
                                    'name': widget.users[index].firstName +
                                        " " +
                                        widget.users[index].lastName,
                                    'urlAvatar': widget.users[index].urlAvatar,
                                    'isMe': false,
                                    'isDriver': driver.exists
                                  });
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  key: new Key(index.toString()),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        widget.users[index].urlAvatar),
                                  ),
                                  title: getTitle(
                                      fontSize: 18,
                                      title: widget.users[index].firstName +
                                          " " +
                                          widget.users[index].lastName,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                ),
                                getTitle(
                                    title:
                                        "Meeting point: ${widget.rideRequests[index].pickUpLocation}",
                                    fontSize: 16,
                                    color: kPrimaryColor),
                                getTitle(
                                    title:
                                        "Number of passengers: ${widget.rideRequests[index].numOfPassengers}",
                                    fontSize: 16,
                                    color: kPrimaryColor),
                                widget.rideRequests[index].status == 'pending'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          IconButton(
                                            icon: Icon(Icons
                                                .check_circle_outline_rounded),
                                            onPressed: () async {
                                              widget.driverRide
                                                          .numOfPassengers >=
                                                      widget.rideRequests[index]
                                                          .numOfPassengers
                                                  ? await FirebaseFirestore
                                                      .instance
                                                      .collection('requests')
                                                      .doc(widget
                                                          .rideRequests[index]
                                                          .ride)
                                                      .update({
                                                      'status': 'accepted'
                                                    }).then((_) async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('rides')
                                                          .doc(widget.driverRide
                                                              .driver)
                                                          .collection(
                                                              'userrides')
                                                          .doc(widget
                                                              .driverRide.id)
                                                          .update({
                                                        'numOfPassengers': widget
                                                                .driverRide
                                                                .numOfPassengers -
                                                            widget
                                                                .rideRequests[
                                                                    index]
                                                                .numOfPassengers
                                                      });
                                                      setState(() {
                                                        widget.driverRide
                                                                .numOfPassengers -=
                                                            widget
                                                                .rideRequests[
                                                                    index]
                                                                .numOfPassengers;
                                                        widget
                                                            .rideRequests[index]
                                                            .status = 'accepted';
                                                      });
                                                    })
                                                  : ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          content: Text(
                                                              "Number of passengers is bigger than the number of seats left")));
                                            },
                                            iconSize: 45,
                                            color: Colors.green,
                                          ),
                                          IconButton(
                                              icon: Icon(Icons
                                                  .highlight_remove_rounded),
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('requests')
                                                    .doc(widget
                                                        .rideRequests[index]
                                                        .ride)
                                                    .update({
                                                  'status': 'rejected'
                                                }).then((_) {
                                                  setState(() {
                                                    widget.users
                                                        .removeAt(index);
                                                    widget.rideRequests
                                                        .removeAt(index);
                                                  });
                                                });
                                              },
                                              iconSize: 45,
                                              color: Colors.red),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                              ),
                                              Text(
                                                'Ride Accepted',
                                                style: blueSubHeadingTextStyle,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                          isBefore
                                              ? CustomElevatedButton(
                                                  backgroundColor: redColor,
                                                  title: "Write a Review",
                                                  color: Colors.white,
                                                  onPressed: () =>
                                                      _modalBottomSheetMenu(
                                                          widget
                                                              .rideRequests[
                                                                  index]
                                                              .currentUser),
                                                )
                                              : Container()
                                        ],
                                      ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

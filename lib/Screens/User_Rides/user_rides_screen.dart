import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Driver_Rides/requests.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart' as User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../constants.dart';
import '../../text_style.dart';

class UserRides extends StatefulWidget {
  static const routeName = '/userrides';
  final List<Ride> userRidesDetails;
  final List<SearchedRide> userRides;
  final List<User.User> drivers;
  const UserRides(
      {Key key, this.userRidesDetails, this.userRides, this.drivers})
      : super(key: key);

  @override
  _UserRidesState createState() => _UserRidesState();
}

Widget driverProfile(User.User driver, Ride ride, BuildContext ctx) {
  return GestureDetector(
    onTap: () {
      Navigator.of(ctx).pushNamed(ProfileScreen.routeName, arguments: {
        'id': ride.driver,
        'name': driver.firstName + " " + driver.lastName,
        'urlAvatar': driver.urlAvatar,
        'isMe': false,
      });
    },
    child: Text("Driver: " + driver.firstName + " " + driver.lastName,
        style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
            decoration: TextDecoration.underline)),
  );
}

class _UserRidesState extends State<UserRides> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  double rating;
  String review;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();
  checkReviewed(String driverId, String rideId) async {
    var reviews = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(driverId)
        .collection("reviews")
        .get();

    reviews.docs.forEach((element) {
      if (uid == element.data()["reviewerId"] &&
          rideId == element.data()["rideId"]) {
        print("true");
        return true;
      }
    });
    return false;
  }

  _trySubmit(BuildContext ctx, String reviewdId, String rideId) async {
    print(rating);
    final isValid = _formKey.currentState.validate();
    FocusScope.of(ctx).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      await FirebaseFirestore.instance
          .collection("drivers")
          .doc(reviewdId)
          .collection("reviews")
          .doc()
          .set({
        "rating": rating,
        "review": review,
        "dateTime": DateTime.now(),
        "reviewerId": uid,
        "rideId": rideId
      });
      _textFieldController.clear();
      await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Confirmation'),
                content: Text('Your review has been submitted!'),
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

  void _modalBottomSheetMenu(
      BuildContext context, String reviewedId, String rideId) {
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
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            CustomElevatedButton(
                              title: "Post",
                              backgroundColor: redColor,
                              color: Colors.white,
                              onPressed: () =>
                                  _trySubmit(context, reviewedId, rideId),
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

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  bool already;
  getUser() {
    uid = auth.currentUser.uid;
  }

  var backBtnRes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getTitle(
              title: "My Requested Rides", color: redColor, fontSize: 20),
          backgroundColor: Colors.white,
        ),
        body: widget.userRides.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "You haven't requested any ride yet!",
                    style: redSubHeadingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : ListView.builder(
                itemCount: widget.userRides.length,
                itemBuilder: (ctx, index) {
                  bool isBefore = DateFormat("EEE, MMM d")
                      .parse(widget.userRides[index].date)
                      .isBefore(DateTime.now());
                  return CustomContainer(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          leading: CircleAvatar(
                            backgroundColor: redColor,
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: FittedBox(
                                child: Text(
                                  "${widget.userRidesDetails[index].price}₪",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          title: getTitle(
                              title:
                                  "From ${widget.userRidesDetails[index].startLocation}, \nTo ${widget.userRidesDetails[index].arrivalLocation}",
                              color: Colors.brown[500],
                              fontSize: 16),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: widget.userRidesDetails[index].stopOvers
                                            .length ==
                                        0 &&
                                    widget.userRidesDetails[index]
                                            .description ==
                                        null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      driverProfile(widget.drivers[index],
                                          widget.userRidesDetails[index], ctx),
                                      Text(
                                        "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )
                                : widget.userRidesDetails[index].stopOvers
                                                .length >
                                            0 &&
                                        widget.userRidesDetails[index]
                                                .description ==
                                            null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          driverProfile(
                                              widget.drivers[index],
                                              widget.userRidesDetails[index],
                                              ctx),
                                          Text(
                                            "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}\n\nStopovers: \n${widget.userRidesDetails[index].stopOvers.where((item) => item.contains('')).join('\n')}",
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14),
                                          ),
                                        ],
                                      )
                                    : widget.userRidesDetails[index].stopOvers
                                                    .length ==
                                                0 &&
                                            widget.userRidesDetails[index]
                                                    .description !=
                                                null
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              driverProfile(
                                                  widget.drivers[index],
                                                  widget
                                                      .userRidesDetails[index],
                                                  ctx),
                                              Text(
                                                "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}\n\nAdditional info: ${widget.userRidesDetails[index].description}",
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              driverProfile(
                                                  widget.drivers[index],
                                                  widget
                                                      .userRidesDetails[index],
                                                  ctx),
                                              Text(
                                                "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}\n\nStopovers: \n${widget.userRidesDetails[index].stopOvers.where((item) => item.contains('')).join('\n')}\n\nAdditional info: ${widget.userRidesDetails[index].description}",
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                          ),
                        ),
                        CustomElevatedButton(
                          backgroundColor: redColor,
                          title: "Delete",
                          color: Colors.white,
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            DateTime rideDate = new DateFormat('EEE, MMM d')
                                .parse(widget.userRides[index].date);
                            if (widget.userRides[index].status == "pending") {
                              await showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Confirmation!'),
                                  content: Text(
                                      'Are you sure you want to delete this ride request?'),
                                  actions: [
                                    new TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Cancel'),
                                    ),
                                    new TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(
                                                widget.userRides[index].request)
                                            .delete()
                                            .then((value) {
                                          setState(() {
                                            widget.drivers.removeAt(index);
                                            widget.userRides.removeAt(index);
                                            widget.userRidesDetails
                                                .removeAt(index);
                                          });
                                        });
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      /*  */

                                      child: new Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ).catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                            } else if (widget.userRides[index].status ==
                                        "accepted" &&
                                    rideDate.month > now.month ||
                                (rideDate.day >= now.day &&
                                    rideDate.month == now.month)) {
                              await showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Confirmation!'),
                                  content: Text(
                                      'Are you sure you want to delete this ride request? It has been already accepted'),
                                  actions: [
                                    new TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Cancel'),
                                    ),
                                    new TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(
                                                widget.userRides[index].request)
                                            .delete()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection('rides')
                                              .doc(widget
                                                  .userRidesDetails[index]
                                                  .driver)
                                              .collection('userrides')
                                              .doc(widget.userRides[index].ride)
                                              .update({
                                            'numOfPassengers': widget
                                                    .userRidesDetails[index]
                                                    .numOfPassengers +
                                                widget.userRides[index]
                                                    .numOfPassengers
                                          });
                                          setState(() {
                                            widget.drivers.removeAt(index);
                                            widget.userRides.removeAt(index);
                                            widget.userRidesDetails
                                                .removeAt(index);
                                          });
                                        });
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ).catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                            } else {
                              await showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Confirmation!'),
                                  content: Text(
                                      'Do you want to delete this ride request?'),
                                  actions: [
                                    new TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Cancel'),
                                    ),
                                    new TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(
                                                widget.userRides[index].request)
                                            .delete()
                                            .then((value) {
                                          setState(() {
                                            widget.drivers.removeAt(index);
                                            widget.userRides.removeAt(index);
                                            widget.userRidesDetails
                                                .removeAt(index);
                                          });
                                        });
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      /*  */

                                      child: new Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ).catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                            }
                          },
                        ),
                        checkReviewed(widget.userRidesDetails[index].driver,
                                widget.userRides[index].ride)
                            ? CustomElevatedButton(
                                backgroundColor: redColor,
                                title: "Write a Review",
                                color: Colors.white,
                                onPressed: () => _modalBottomSheetMenu(
                                    context,
                                    widget.userRidesDetails[index].driver,
                                    widget.userRides[index].ride),
                              )
                            : Container()
                      ],
                    ),
                  );
                },
              ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

class UserReview extends StatelessWidget {
  final String reviewerId;
  final String date;
  final String review;

  const UserReview(
      {Key key,
      @required this.reviewerId,
      @required this.date,
      @required this.review})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(reviewerId).get(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
              return getTitle(title: getTranslated(context, "sthwrong"));
            } else {
              final name = snapshot.data.data()["firstName"] +
                  " " +
                  snapshot.data.data()["lastName"];
              final urlAvatar = snapshot.data.data()["urlAvatar"];

              if (name.isEmpty) {
                return Container();
              } else
                return Card(
                    // color: kCardColor,
                    elevation: 0,
                    // color: Color(0xfff1f4f9),
                    // margin: EdgeInsets.symmetric(
                    //   vertical: 8,
                    //   horizontal: 8,
                    // ),
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Image.network(urlAvatar),
                        ),
                        title: getTitle(
                            title: name,
                            color: Colors.brown[500],
                            fontSize: 14),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTitle(
                              title: review,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            getTitle(
                              title: date,
                              color: Colors.blueGrey,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                    ));
            }
        }
      },
    );
  }
}

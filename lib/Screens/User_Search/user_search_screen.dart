import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

class UserSearchScreen extends StatefulWidget {
  static const routeName = '/user_search';

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  String query = "";

  Stream<List<QuerySnapshot>> getUserList() {
    Stream<QuerySnapshot> documentList1;
    Stream<QuerySnapshot> documentList2;
    if (query == "") {
      return null;
    } else {
      documentList1 = FirebaseFirestore.instance
          .collection("users")
          .where("firstName", isEqualTo: query)
          .snapshots();

      documentList2 = FirebaseFirestore.instance
          .collection("users")
          .where("lastName", isEqualTo: query)
          .snapshots();
      return StreamZip([documentList1, documentList2]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'srchforausr')),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RoundedInputField(
              onChanged: (String srchquery) {
                setState(() {
                  this.query = srchquery;
                });
              },
            ),
            StreamBuilder(
                stream: getUserList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Text('Loading'),
                          ],
                        ),
                      );
                    default:
                      List<QuerySnapshot> querySnapshotData;
                      if (snapshot.data == null) {
                        return Container();
                      } else
                        querySnapshotData = snapshot.data.toList();
                      querySnapshotData[0]
                          .docs
                          .addAll(querySnapshotData[1].docs);
                      List<QueryDocumentSnapshot> query =
                          querySnapshotData[0].docs;
                      return Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10.0),
                              itemCount: query.length,
                              itemBuilder: (context, index) {
                                var user = query[index];
                                // return buildUserRow(snapshot.data.documents[index]);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        ProfileScreen.routeName,
                                        arguments: {
                                          'id': user.id,
                                          'name': user.data()["firstName"] +
                                              " " +
                                              user.data()["lastName"],
                                          'urlAvatar': user.data()["urlAvatar"],
                                          'isMe': false,
                                        });
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          user.data()["urlAvatar"]),
                                    ),
                                    title: Text(user.data()["firstName"] +
                                        " " +
                                        user.data()["lastName"]),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            ),
                          ],
                        ),
                      );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

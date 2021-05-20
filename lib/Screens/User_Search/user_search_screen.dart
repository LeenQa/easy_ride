import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class UserSearchScreen extends StatefulWidget {
  static const routeName = '/user_search';

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  String query = "";

  Stream<QuerySnapshot> getUserList() {
    Stream<QuerySnapshot> documentList;
    if (query == "") {
      return null;
    } else {
      documentList = FirebaseFirestore.instance
          .collection("users")
          .where("searchIndex", arrayContains: query.toLowerCase())
          .snapshots();
      return documentList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: getTitle(
            title: getTranslated(context, 'srchforausr'),
            color: kPrimaryColor,
            fontSize: 20),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RoundedInputField(
                icon: Icons.search,
                hintText: getTranslated(context, "typeusername"),
                onChanged: (String srchquery) {
                  setState(() {
                    this.query = srchquery;
                  });
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: getUserList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return new Text(
                          '${getTranslated(context, "error")}: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: Column(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              getTitle(
                                  title: getTranslated(context, "loading")),
                            ],
                          ),
                        );
                      default:
                        if (snapshot.data == null) {
                          return Container();
                        } else
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(10.0),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    var user = snapshot.data.docs[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        var isDriver = await FirebaseFirestore
                                            .instance
                                            .collection("drivers")
                                            .doc(user.id)
                                            .get();
                                        Navigator.of(context).pushNamed(
                                            ProfileScreen.routeName,
                                            arguments: {
                                              'id': user.id,
                                              'name': user.data()["firstName"] +
                                                  " " +
                                                  user.data()["lastName"],
                                              'urlAvatar':
                                                  user.data()["urlAvatar"],
                                              'isMe': false,
                                              'isDriver': isDriver.exists
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
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/chat_body_widget.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  getUser() {
    uid = auth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('conversations')
                .orderBy("lastMessageTime", descending: true)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                        child: getTitle(
                            title: getTranslated(context, "sthwrong")));
                  } else {
                    final conversations = snapshot.data.docs;

                    if (conversations.isEmpty) {
                      return Center(
                          child: getTitle(title: 'No Conversations Found'));
                    } else
                      return Column(
                        children: [
                          ChatBodyWidget(conversations: conversations, uid: uid)
                        ],
                      );
                  }
              }
            },
          ),
        ),
      );
}

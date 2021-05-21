import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/message_widget.dart';
import 'package:flutter/material.dart';

class MessagesWidget extends StatefulWidget {
  final String convId;
  final String urlAvatar;
  MessagesWidget({
    @required this.convId,
    @required this.urlAvatar,
    Key key,
  }) : super(key: key);

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
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

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("conversationmsgs")
          .doc(widget.convId.trim())
          .collection("messages")
          .orderBy("dateTime", descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(
                  child: getTitle(title: 'Something Went Wrong Try later'));
            } else if (!snapshot.hasData) {
              return Center(child: getTitle(title: 'No Data'));
            } else {
              final messages = snapshot.data.docs;
              return messages == null
                  ? Center(child: getTitle(title: 'Say Hi..'))
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        String message = messages[index].data()["content"];

                        return MessageWidget(
                          message: message,
                          isMe:
                              messages[index].data()["senderId"].trim() == uid,
                          urlAvatar: widget.urlAvatar,
                        );
                      },
                    );
            }
        }
      },
    );
  }
}

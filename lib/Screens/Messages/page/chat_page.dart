import 'package:easy_ride/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/messages_widget.dart';
import '../widget/new_message_widget.dart';
import '../widget/profile_header_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String convId;
  final String name;
  final String urlAvatar;
  final String chatUser;

  const ChatPage({
    @required this.convId,
    @required this.name,
    @required this.urlAvatar,
    @required this.chatUser,
    Key key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
        extendBodyBehindAppBar: true,
        backgroundColor: kPrimaryColor,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.name),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(
                    convId: widget.convId,
                    urlAvatar: widget.urlAvatar,
                  ),
                ),
              ),
              NewMessageWidget(
                convId: widget.convId,
                userId: uid,
                chatUser: widget.chatUser,
              )
            ],
          ),
        ),
      );
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Assistants/assistantMethods.dart';
import 'package:easy_ride/components/keys.dart';
import 'package:easy_ride/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NewMessageWidget extends StatefulWidget {
  final String convId;
  final String userId;
  final String chatUser;

  const NewMessageWidget({
    @required this.convId,
    @required this.userId,
    @required this.chatUser,
    Key key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';
  String token = '';
  String firstName = '';
  String lastName = '';
  String urlAvatar = '';
  bool areChatNotificationsTurnedOn = true;
  void sendMessage() async {
    // FocusScope.of(context).unfocus();
    if (message != "") {
      await FirebaseFirestore.instance
          .collection("conversationmsgs")
          .doc(widget.convId.trim())
          .collection("messages")
          .doc()
          .set({
        "content": message,
        "dateTime": DateTime.now(),
        "senderId": widget.userId,
      });
      _controller.clear();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("conversations")
          .doc(widget.convId.trim())
          .update({
        "lastMessageTime": DateTime.now(),
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get()
          .then((value) {
        firstName = value.data()['firstName'];
        lastName = value.data()['lastName'];
        urlAvatar = value.data()['urlAvatar'];
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.chatUser)
          .get()
          .then((value) {
        token = value.data()['token'];
        areChatNotificationsTurnedOn = value.data()['getChatNotifications'];
        if (token != '') {
          print(token);
          OneSignal.shared.setNotificationWillShowInForegroundHandler(
              (OSNotificationReceivedEvent event) {
            event.complete(null);
          });
          if (areChatNotificationsTurnedOn) {
            AssistantMethods.sendNotification(
                [token], message, firstName + " " + lastName, urlAvatar);
          }
        }
        message = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Type your message',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: message.trim() == "" ? null : sendMessage,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.send, color: kPrimaryColor),
              ),
            ),
          ],
        ),
      );
}

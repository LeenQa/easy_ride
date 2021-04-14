import 'package:easy_ride/Screens/Messages/users.dart';
import 'package:flutter/material.dart';

import 'api/firebase_api.dart';
import 'page/chats_page.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Future addUsers() async {
    await FirebaseApi.addRandomUsers(Users.initUsers);
  }

  @override
  void initState() {
    addUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChatsPage();
  }
}

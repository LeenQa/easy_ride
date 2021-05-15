import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:intl/intl.dart';
import '../page/chat_page.dart';
import 'package:flutter/material.dart';

class ChatBodyWidget extends StatefulWidget {
  final List<QueryDocumentSnapshot> conversations;
  final String uid;

  ChatBodyWidget({
    @required this.conversations,
    @required this.uid,
    Key key,
  }) : super(key: key);

  @override
  _ChatBodyWidgetState createState() => _ChatBodyWidgetState();
}

class _ChatBodyWidgetState extends State<ChatBodyWidget> {
  getUserData(String userid) async {
    var userdata =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
  }

  //final AsyncMemoizer _memoizer = AsyncMemoizer();
  getConversations(String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final userId = widget.conversations[index].data()["receiverId"];
          final time = widget.conversations[index].data()["lastMessageTime"];
          return Container(
            height: 75,
            child: FutureBuilder(
              future: getConversations(userId),
              builder: (BuildContext context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text('Something Went Wrong Try later');
                    } else if (!snapshot.hasData) {
                      return Text('No Data');
                    } else {
                      final name = snapshot.data.data()["firstName"] +
                          " " +
                          snapshot.data.data()["lastName"];
                      final urlAvatar = snapshot.data.data()["urlAvatar"];
                      // final user = widget.uid == uid1
                      //     ? snapshot.data.data()["userId2"].trim()
                      //     : uid1;
                      // getUserData(user.trim());
                      if (name == null) {
                        return Text('No Conversations Found');
                      } else
                        return Column(
                          children: [
                            //ChatHeaderWidget(users: users),
                            //ChatBodyWidget(conversations: user),
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    convId: widget.conversations[index].id,
                                    name: name,
                                    urlAvatar: urlAvatar,
                                    chatUser: userId,
                                  ),
                                ));
                              },
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(urlAvatar), //urlavatar
                              ),
                              title: getTitle(
                                  title: name, color: Colors.black), //name
                              subtitle: getTitle(
                                  title: DateFormat(
                                          'EEE, MMM d y \'at\' H:mm:s')
                                      .format(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              time.microsecondsSinceEpoch))
                                      .toString(),
                                  fontSize: 13),
                            ),
                          ],
                        );
                    }
                }
              },
            ),
          );
        },
        itemCount: widget.conversations.length,
      );
}

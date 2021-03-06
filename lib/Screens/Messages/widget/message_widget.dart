import 'package:easy_ride/constants.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final String urlAvatar;
  final bool isMe;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
    @required this.urlAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(radius: 16, backgroundImage: NetworkImage(urlAvatar)),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : kPrimaryColor,
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );
}

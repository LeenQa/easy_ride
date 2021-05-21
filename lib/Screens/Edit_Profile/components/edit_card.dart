import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class EditCard extends StatelessWidget {
  final String title;
  final Function(BuildContext, String) showDialog;
  final String methodTitle;

  const EditCard(
      {Key key,
      @required this.title,
      @required this.showDialog,
      @required this.methodTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryColor,
      onTap: () {
        showDialog(context, methodTitle);
      },
      child: Card(
        child: ListTile(
          leading: getTitle(title: title, color: Colors.white),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
        ),
        color: kPrimaryColor,
        elevation: 5,
      ),
    );
  }
}

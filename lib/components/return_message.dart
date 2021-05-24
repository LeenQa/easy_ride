import 'package:easy_ride/components/main_drawer.dart';
import 'package:flutter/material.dart';

class ReturnMessage {
  static success(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[400],
        content: getTitle(title: message, color: Colors.white)));
  }

  static fail(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: getTitle(title: message, color: Colors.white)));
  }

  static wait(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange[400],
        content: getTitle(title: message, color: Colors.white)));
  }
}

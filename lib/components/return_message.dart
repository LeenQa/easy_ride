import 'package:flutter/material.dart';

class ReturnMessage {
  static success(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green[400], content: Text(message)));
  }

  static fail(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red[400], content: Text(message)));
  }
}

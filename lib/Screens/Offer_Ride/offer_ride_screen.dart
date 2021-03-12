import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

class OfferRideScreen extends StatelessWidget {
  static const routeName = '/offer_ride';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'offrard')),
      ),
      body: Container(
        child: Text("Offer Ride"),
      ),
    );
  }
}

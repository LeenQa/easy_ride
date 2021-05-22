import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(child: MulticityInput()),
    );
  }
}

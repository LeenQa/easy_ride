import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _fromChosenValue;
  String _toChosenValue;
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    List<String> cities = <String>[
      getTranslated(context, "jerusalem"),
      getTranslated(context, "bethlehem"),
      getTranslated(context, "ramallah"),
      getTranslated(context, "nablus"),
      getTranslated(context, "hebron"),
      getTranslated(context, "jericho"),
      getTranslated(context, "jenin"),
      getTranslated(context, "tulkarem"),
      getTranslated(context, "qalqilya"),
    ];
    @override
    void initState() {
      super.initState();
      _fromChosenValue = cities[0];
      _toChosenValue = cities[1];
    }

    return Container(
      child: SingleChildScrollView(child: MulticityInput()),
    );
  }
}

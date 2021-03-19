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

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 200)),
      //execute when user chooses a date
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedDate = value;
      });
    });
  }

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
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(selectedDate == null
                  ? 'No Date Chosen!'
                  : DateFormat.yMEd().format(selectedDate)),
            ],
          ),
          TextButton(
            onPressed: _presentDatePicker,
            child: Text(
              'Choose Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

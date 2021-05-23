import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale locale;

  // _changeSettings() async {
  //   var documents = await FirebaseFirestore.instance.collection("users").get();
  //   documents.docs.forEach((element) async {
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(element.id)
  //         .update({
  //       "showPhone": false,
  //       "getChatNotifications": false,
  //       "getReminderNotifications": false,
  //       "getRequestNotifications": false,
  //     });
  //   });
  // }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  bool langValue;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLocale().then((locale) {
      if (locale.languageCode.contains('en')) {
        langValue = true;
      }
      langValue = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  getUser() {
    final User user = auth.currentUser;
    uid = user.uid;
  }

  bool _value = false;
  void _onChanged(bool value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitle(
            title: getTranslated(context, 'settings'),
            color: kPrimaryColor,
            fontSize: 20),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.language,
                color: kPrimaryColor,
              ),
              title: DropdownButton<Language>(
                underline: SizedBox(),
                hint: getTitle(
                    title: getTranslated(context, "switchlang"),
                    fontWeight: FontWeight.w500),
                onChanged: (Language language) {
                  _changeLanguage(language);
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                          value: e, child: getTitle(title: e.name)),
                    )
                    .toList(),
              ),
            ),
            // CustomElevatedButton(
            //     title: "settings", color: Colors.white, onPressed: () {}),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var setting = snapshot.data;
                  bool chatNotif = setting.data()["getChatNotifications"];
                  bool requestNotif = setting.data()["getRequestNotifications"];
                  bool showPhone = setting.data()["showPhone"];

                  return Column(
                    children: [
                      SwitchListTile.adaptive(
                          title: getTitle(title: 'Receive Chat Notifications'),
                          activeColor: kPrimaryColor,
                          secondary: const Icon(
                            Icons.notifications,
                            color: kPrimaryColor,
                          ),
                          value: chatNotif,
                          onChanged: (bool value) async {
                            chatNotif = !chatNotif;
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid)
                                .update({"getChatNotifications": chatNotif});
                          }),
                      SwitchListTile.adaptive(
                          title:
                              getTitle(title: 'Receive Request Notifications'),
                          activeColor: kPrimaryColor,
                          secondary: const Icon(
                            Icons.notifications,
                            color: kPrimaryColor,
                          ),
                          value: requestNotif,
                          onChanged: (bool value) async {
                            chatNotif = !chatNotif;
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid)
                                .update(
                                    {"getRequestNotifications": requestNotif});
                          }),
                      SwitchListTile.adaptive(
                          title:
                              getTitle(title: 'Show phone number in profile'),
                          activeColor: kPrimaryColor,
                          secondary: const Icon(
                            Icons.phone,
                            color: kPrimaryColor,
                          ),
                          value: showPhone,
                          onChanged: (bool value) async {
                            showPhone = !showPhone;
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid)
                                .update({"showPhone": showPhone});
                          }),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "", "English", "en"),
      Language(2, "", "اَلْعَرَبِيَّةُ‎", "ar"),
    ];
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Edit_Profile/components/edit_card.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/return_message.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/Screens/Signup/components/field_validation.dart';
import 'package:string_validator/string_validator.dart';

class ProfilePicScreen extends StatefulWidget {
  static const String routeName = '/editprofilescreen';

  @override
  _ProfilePicScreenState createState() => _ProfilePicScreenState();
}

class _ProfilePicScreenState extends State<ProfilePicScreen> {
  File _image;
  final picker = ImagePicker();
  String _uploadedFileURL;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  String currValidatorResponse = null;
  String newValidatorResponse = null;

  // String valid() {
  //   Map args = ModalRoute.of(context).settings.arguments;
  //   if (_textFieldController.text.trim() == "" ||
  //       _textFieldController.text == null ||
  //       _textFieldController2.text.trim() == "" ||
  //       _textFieldController2.text == null) {
  //     return "please provide a value";
  //   } else
  //     return null;
  // }
  List<String> searchIndex(String firstname, String lastname) {
    List<String> indexList = [];
    String name = firstname + " " + lastname;

    for (int i = 1; i <= name.length; i++) {
      if (i <= firstname.length) {
        indexList.add(firstname.substring(0, i).toLowerCase());
      }
      if (i <= lastname.length) {
        indexList.add(lastname.substring(0, i).toLowerCase());
      }
      if (i > firstname.length - 1) {
        indexList.add(name.substring(0, i).toLowerCase());
      }
    }
    return indexList;
  }

  Future<String> validPass() async {
    Map args = ModalRoute.of(context).settings.arguments;
    if (_textFieldController.text.trim() == "" ||
        _textFieldController.text == null ||
        _textFieldController2.text.trim() == "" ||
        _textFieldController2.text == null) {
      if (_textFieldController.text.trim() == "" ||
          _textFieldController.text == null) {
        setState(() {
          currValidatorResponse = getTranslated(context, "pleaseprovidevalue");
        });
      }
      if (_textFieldController2.text.trim() == "" ||
          _textFieldController2.text == null) {
        setState(() {
          newValidatorResponse = getTranslated(context, "pleaseprovidevalue");
        });
      }
    } else {
      String valid =
          FieldValidation.validatePassword(_textFieldController2.text, context);
      if (valid == null) {
        var message;
        var user = await FirebaseFirestore.instance
            .collection("users")
            .doc(args["id"])
            .get();
        String email = user.data()["email"];
        try {
          final curruser = (await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: email, password: _textFieldController.text))
              .user;

          await curruser.updatePassword(_textFieldController2.text);
          message = 'true';
        } on PlatformException catch (err) {
          message = getTranslated(context, "checkcredentials");
          if (err.message != null) {
            message = err.message;
          }
        } on FirebaseException catch (err) {
          message = err.code;
        }
        if (message == 'wrong-password') {
          setState(() {
            currValidatorResponse = getTranslated(context, "writepasscorrect");
          });
        } else if (message == 'true') {
          setState(() {
            currValidatorResponse = null;
            newValidatorResponse = null;
          });
        } else {
          setState(() {
            newValidatorResponse = message;
          });
        }
      } else
        setState(() {
          newValidatorResponse = getTranslated(context, "weakpassword");
        });
    }
  }

  Future<void> _changePhoneDialog(BuildContext context, String text) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text, color: kPrimaryColor),
          content: Form(
            key: _formKeyPhone,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _textFieldController,
                    validator: (value) {
                      if (value == "") {
                        return getTranslated(context, "pleaseprovidevalue");
                      } else if (value.length > 15 || value.length < 7) {
                        return getTranslated(context, "phoneerror");
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                        errorMaxLines: 5,
                        hintText: getTranslated(context, "phone")),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: getTitle(
                  title: getTranslated(context, "cancel"),
                  color: kPrimaryColor),
              onPressed: () {
                _textFieldController.text = "";
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: getTitle(
                    title: getTranslated(context, "update"),
                    color: kPrimaryColor),
                onPressed: () async {
                  final isValid = _formKeyPhone.currentState.validate();
                  if (isValid) {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(args["id"])
                        .update({"phone": _textFieldController.text});
                    _textFieldController.text = "";
                    ReturnMessage.success(
                        context, getTranslated(context, "phoneupdated"));
                    Navigator.of(context).pushNamed(TabsScreen.routeName);
                  }
                }),
          ],
        );
      },
    );
  }

  Future<void> _changeNameDialog(BuildContext context, String text) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text, color: kPrimaryColor),
          content: Container(
            height: 150,
            child: Form(
              key: _formKeyName,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == "" || value == null) {
                          return getTranslated(context, "pleaseprovidevalue");
                        } else if (!isAlpha(value)) {
                          return getTranslated(context, "nameerror");
                        } else
                          return null;
                      },
                      controller: _textFieldController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          errorMaxLines: 5,
                          hintText: getTranslated(context, "firstname")),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == "" || value == null) {
                          return getTranslated(context, "pleaseprovidevalue");
                        } else if (!isAlpha(value)) {
                          return getTranslated(context, "nameerror");
                        } else
                          return null;
                        ;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      controller: _textFieldController2,
                      decoration: InputDecoration(
                          errorMaxLines: 5,
                          hintText: getTranslated(context, "lastname")),
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: getTitle(
                  title: getTranslated(context, "cancel"),
                  color: kPrimaryColor),
              onPressed: () {
                _textFieldController.text = "";
                _textFieldController2.text = "";
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: getTitle(
                  title: getTranslated(context, "update"),
                  color: kPrimaryColor),
              onPressed: () async {
                final isValid = _formKeyName.currentState.validate();
                if (isValid) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(args["id"])
                      .update({
                    "firstName": _textFieldController.text,
                    "lastName": _textFieldController2.text,
                    'searchIndex': searchIndex(
                        _textFieldController.text, _textFieldController2.text),
                  });
                  already
                      ? await FirebaseFirestore.instance
                          .collection("driver_requests")
                          .doc(args["id"])
                          .update({
                          "firstName": _textFieldController.text,
                          "lastName": _textFieldController2.text,
                        })
                      // ignore: unnecessary_statements
                      : null;

                  ReturnMessage.success(
                      context, getTranslated(context, "nameupdated"));
                  _textFieldController.text = "";
                  _textFieldController2.text = "";
                  Navigator.of(context).pushNamed(TabsScreen.routeName);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePasswordDialog(BuildContext context, String text) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text, color: kPrimaryColor),
          content: Container(
            height: 150,
            child: Form(
              key: _formKeyPassword,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        return currValidatorResponse;
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(
                          errorMaxLines: 5,
                          hintText: getTranslated(context, "currpass")),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        return newValidatorResponse;
                      },
                      controller: _textFieldController2,
                      decoration: InputDecoration(
                          errorMaxLines: 5,
                          hintText: getTranslated(context, "newpass")),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: getTitle(
                  title: getTranslated(context, "cancel"),
                  color: kPrimaryColor),
              onPressed: () {
                _textFieldController.text = "";
                _textFieldController2.text = "";
                currValidatorResponse = null;
                newValidatorResponse = null;
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: getTitle(
                    title: getTranslated(context, "update"),
                    color: kPrimaryColor),
                onPressed: () async {
                  validPass();
                  final isValid = _formKeyPassword.currentState.validate();
                  if (isValid) {
                    ReturnMessage.success(
                        context, getTranslated(context, "passupdated"));
                    _textFieldController.text = "";
                    _textFieldController2.text = "";
                    currValidatorResponse = null;
                    newValidatorResponse = null;
                    Navigator.of(context).pushNamed(TabsScreen.routeName);
                  }
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: getTitle(
              title: getTranslated(context, 'editprofile'),
              color: kPrimaryColor,
              fontSize: 20),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EditCard(
                methodTitle: "photoselectiondialog",
                showDialog: _showSelectionDialog,
                title: getTranslated(context, "updatephoto"),
              ),
              SizedBox(height: 10),
              EditCard(
                title: getTranslated(context, "updatename"),
                showDialog: _changeNameDialog,
                methodTitle: getTranslated(context, "typename"),
              ),
              SizedBox(height: 10),
              EditCard(
                title: getTranslated(context, "updatephone"),
                showDialog: _changePhoneDialog,
                methodTitle: getTranslated(context, "typephone"),
              ),
              SizedBox(height: 10),
              EditCard(
                title: getTranslated(context, "updatepassword"),
                showDialog: _changePasswordDialog,
                methodTitle: getTranslated(context, "typepassword"),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    Map args = ModalRoute.of(context).settings.arguments;
    setState(() async {
      if (pickedFile != null) {
        ReturnMessage.wait(context, getTranslated(context, "pleasewait"));
        _image = File(pickedFile.path);
        Reference storageReference;
        storageReference = FirebaseStorage.instance
            .ref()
            .child('profilepics/${Path.basename(_image.path)}');
        UploadTask uploadTask = storageReference.putFile(File(_image.path));
        await uploadTask.whenComplete(() {
          print('File Uploaded');
          print(args["id"]);
          storageReference.getDownloadURL().then((fileURL) async {
            _uploadedFileURL = fileURL;
            print(fileURL);
            already
                ? await FirebaseFirestore.instance
                    .collection("driver_requests")
                    .doc(args["id"])
                    .update({
                    'urlAvatar': _uploadedFileURL,
                  })
                // ignore: unnecessary_statements
                : null;
            await FirebaseFirestore.instance
                .collection('users')
                .doc(args["id"])
                .update({
              'urlAvatar': _uploadedFileURL,
            }).then((value) => ReturnMessage.success(
                    context, getTranslated(context, "ppupdated")));
          });
        });
      } else
        ReturnMessage.fail(context, getTranslated(context, "photoerror"));
    });
  }

  Future _showSelectionDialog(BuildContext ctx, String title) async {
    await showDialog(
      builder: (context) => SimpleDialog(
        title: getTitle(title: 'Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: getTitle(title: 'From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: getTitle(title: getTranslated(context, "selectphoto")),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      context: context,
    );
  }
}

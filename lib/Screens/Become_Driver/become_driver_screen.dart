import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

enum Picture {
  DriverLicense,
  CarLicense,
  CarInsurance,
  DriverIdentity,
  Car,
}

class BecomeDriverScreen extends StatefulWidget {
  static const routeName = '/become_driver';

  @override
  _BecomeDriverScreenState createState() => _BecomeDriverScreenState();
}

class _BecomeDriverScreenState extends State<BecomeDriverScreen> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  User user;
  getUser() {
    final User user = auth.currentUser;
    uid = user.uid;
    this.user = user;
  }

  Map<Picture, PickedFile> _image = {
    Picture.DriverLicense: null,
    Picture.DriverIdentity: null,
    Picture.CarLicense: null,
    Picture.CarInsurance: null,
    Picture.Car: null
  };
  String _uploadedFileURL;
  String _carModel;
  List<String> paymentMethods = ["Master Card", "PayPal"];
  String chosenMethod;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _textFieldController4 = TextEditingController();

  Future chooseFile(Picture picture) async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image.update(picture, (value) => value = image);
      });
    });
  }

  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2022))
        .then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      } else
        return;
    });
  }

  Future uploadFile() async {
    int count = 0;
    List<String> pictures = [];
    String _uploadedImage;
    bool successful = false;
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      print("carmodel: $_carModel");
      print("entered here");
      _image.forEach((key, value) async {
        Reference storageReference;
        switch (key) {
          case Picture.DriverLicense:
            storageReference = FirebaseStorage.instance.ref().child(
                'becomeadriver/driverlicence/${Path.basename(value.path)}}');
            break;
          case Picture.CarLicense:
            storageReference = FirebaseStorage.instance.ref().child(
                'becomeadriver/carlicense/${Path.basename(value.path)}}');
            break;
          case Picture.CarInsurance:
            storageReference = FirebaseStorage.instance.ref().child(
                'becomeadriver/carinsurance/${Path.basename(value.path)}}');
            break;
          case Picture.DriverIdentity:
            storageReference = FirebaseStorage.instance.ref().child(
                'becomeadriver/driveridentity/${Path.basename(value.path)}}');
            break;
          case Picture.Car:
            storageReference = FirebaseStorage.instance
                .ref()
                .child('becomeadriver/car/${Path.basename(value.path)}}');
            break;
          default:
            storageReference = FirebaseStorage.instance
                .ref()
                .child('becomeadriver/${Path.basename(value.path)}}');
        }

        UploadTask uploadTask = storageReference.putFile(File(value.path));
        await uploadTask.whenComplete(() {
          print('File Uploaded');
          storageReference.getDownloadURL().then((fileURL) async {
            _uploadedFileURL = fileURL;
            _uploadedImage = fileURL;
            pictures.add(_uploadedFileURL);
            var firstname = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get()
                .then((value) => value.data()['firstName']);
            var lastname = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get()
                .then((value) => value.data()['lastName']);
            await FirebaseFirestore.instance
                .collection('driver_requests')
                .doc(uid)
                .set({
              'userId': user.uid,
              'firstName': firstname,
              'lastName': lastname,
              'userEmail': user.email,
              'pictures': pictures,
              'carModel': _carModel,
            }).then((value) {
              count++;
              if (count == 4) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Your request is sent successfully')));
                setState(() {
                  _image.clear();
                  _textFieldController.clear();
                  _textFieldController2.clear();
                  _textFieldController3.clear();
                  _textFieldController4.clear();
                });
              } else if (count == 1) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text('Please wait'),
                  duration: Duration(seconds: 3),
                ));
              }
            });
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: getTitle(
            title: getTranslated(context, 'bcmadriver'),
            color: kPrimaryColor,
            fontSize: 20),
        backgroundColor: Colors.white,
      ),
      body: args["already"]
          ? Center(
              child: getTitle(
                  title: "You've already submited your request",
                  color: Colors.blue),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      getTitle(
                          title: 'Upload a picture of your driving license',
                          fontSize: 15),
                      _image[Picture.DriverLicense] != null
                          ? Image.file(
                              File(_image[Picture.DriverLicense].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: "Choose photo",
                        onPressed: () => chooseFile(Picture.DriverLicense),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: 'Upload a picture of your car\'s license',
                          fontSize: 15),
                      _image[Picture.CarLicense] != null
                          ? Image.file(
                              File(_image[Picture.CarLicense].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: "Choose photo",
                        onPressed: () => chooseFile(Picture.CarLicense),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: 'Upload a picture of your car\'s insurance',
                          fontSize: 15),
                      _image[Picture.CarInsurance] != null
                          ? Image.file(
                              File(_image[Picture.CarInsurance].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: "Choose photo",
                        onPressed: () => chooseFile(Picture.CarInsurance),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: 'Upload a picture of your identity',
                          fontSize: 15),
                      _image[Picture.DriverIdentity] != null
                          ? Image.file(
                              File(_image[Picture.DriverIdentity].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: "Choose photo",
                        onPressed: () => chooseFile(Picture.DriverIdentity),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: 'Upload a picture of your car', fontSize: 15),
                      _image[Picture.Car] != null
                          ? Image.file(
                              File(_image[Picture.Car].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: "Choose photo",
                        onPressed: () => chooseFile(Picture.Car),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),

                      RoundedInputField(
                        controller: _textFieldController,
                        hintText: "What's your car model",
                        icon: Icons.car_repair,
                        onSaved: (value) {
                          _carModel = value.trim();
                        },
                      ),
                      Container(height: 20),
                      getTitle(
                          title: 'Fill your payment information', fontSize: 15),
                      RoundedInputField(
                        controller: _textFieldController2,
                        hintText: "Enter the cardholder name",
                        icon: Icons.car_repair,
                        onSaved: (value) {},
                      ),
                      RoundedInputField(
                        controller: _textFieldController3,
                        hintText: "Enter the card number",
                        icon: Icons.car_repair,
                        onSaved: (value) {},
                      ),
                      Container(
                        height: 70,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.date_range, color: kPrimaryColor),
                                SizedBox(
                                  width: 10,
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0)),
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(fontSize: 30))),
                                  onPressed: _presentDatePicker,
                                  child: getTitle(
                                      title: "Choose card's expiry date",
                                      color: Colors.grey[700],
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Text(_selectedDate == null
                                  ? ''
                                  : DateFormat('\'Picked date: \' EEE, MMM d')
                                      .format(_selectedDate)),
                            ),
                          ],
                        ),
                      ),
                      DropdownButton(
                        dropdownColor: Colors.white,
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w500,
                        ),
                        icon: Icon(
                          Icons.payment,
                          color: kPrimaryColor,
                        ),
                        hint: getTitle(
                          title: "Select Payment Method",
                        ),
                        value: chosenMethod,
                        onChanged: (String value) {
                          setState(() {
                            chosenMethod = value;
                          });
                        },
                        items: paymentMethods.map((String method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  method,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      RoundedInputField(
                        controller: _textFieldController4,
                        hintText: "Enter the CVV",
                        icon: Icons.car_repair,
                        onSaved: (value) {},
                      ),
                      // _image != null
                      //     ? RaisedButton(
                      //         child: Text('Clear Selection'),
                      //         //onPressed: (clearSelection),
                      //       )
                      //     : Container(height: 20),
                      // Text('Uploaded Image'),
                      // _uploadedFileURL != null
                      //     ? Image.network(
                      //         _uploadedFileURL,
                      //         height: 150,
                      //       )
                      //     : Container(),
                      Center(
                        child: CustomElevatedButton(
                          title: 'Send Request',
                          onPressed:
                              _image.containsValue(null) ? null : uploadFile,
                          backgroundColor: kPrimaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

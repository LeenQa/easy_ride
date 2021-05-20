import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/return_message.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
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
  String chosenMethod;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _textFieldController4 = TextEditingController();
  bool agree = false;

  Future chooseFile(Picture picture) async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image.update(picture, (value) => value = image);
      });
    });
  }

  Future uploadFile() async {
    if (formKey.currentState.validate()) {
      int count = 0;
      List<String> pictures = [];
      String _uploadedImage;
      bool successful = false;
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        if (agree) {
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
                String firstName = "";
                String lastName = "";
                String urlAvatar = "";
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get()
                    .then((value) {
                  firstName = value.data()['firstName'];
                  lastName = value.data()['lastName'];
                  urlAvatar = value.data()['urlAvatar'];
                }).then((_) async {
                  await FirebaseFirestore.instance
                      .collection('driver_requests')
                      .doc(uid)
                      .set({
                    'userId': user.uid,
                    'firstName': firstName,
                    'lastName': lastName,
                    'userEmail': user.email,
                    'pictures': pictures,
                    'carModel': _carModel,
                    'urlAvatar': urlAvatar,
                  }).then((value) {
                    count++;
                    if (count == 4) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content:
                              Text(getTranslated(context, "successfulreq"))));
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
                        content: Text(getTranslated(context, "pleasewait")),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  });
                });
              });
            });
          });
        } else
          ReturnMessage.fail(context, getTranslated(context, "agreeerror"));
      }
    }
  }

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
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
                  title: getTranslated(context, "alrdysubmitrequest"),
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
                    children: [
                      getTitle(
                          title: getTranslated(context, "drivinglicense"),
                          fontSize: 15),
                      _image[Picture.DriverLicense] != null
                          ? Image.file(
                              File(_image[Picture.DriverLicense].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: getTranslated(context, "choosephoto"),
                        onPressed: () => chooseFile(Picture.DriverLicense),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: getTranslated(context, "carlicense"),
                          fontSize: 15),
                      _image[Picture.CarLicense] != null
                          ? Image.file(
                              File(_image[Picture.CarLicense].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: getTranslated(context, "choosephoto"),
                        onPressed: () => chooseFile(Picture.CarLicense),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: getTranslated(context, "carinsurance"),
                          fontSize: 15),
                      _image[Picture.CarInsurance] != null
                          ? Image.file(
                              File(_image[Picture.CarInsurance].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: getTranslated(context, "choosephoto"),
                        onPressed: () => chooseFile(Picture.CarInsurance),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: getTranslated(context, "identity"),
                          fontSize: 15),
                      _image[Picture.DriverIdentity] != null
                          ? Image.file(
                              File(_image[Picture.DriverIdentity].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: getTranslated(context, "choosephoto"),
                        onPressed: () => chooseFile(Picture.DriverIdentity),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      getTitle(
                          title: getTranslated(context, "carpic"),
                          fontSize: 15),
                      _image[Picture.Car] != null
                          ? Image.file(
                              File(_image[Picture.Car].path),
                              height: 100,
                              width: 100,
                            )
                          : Container(height: 20),
                      CustomElevatedButton(
                        title: getTranslated(context, "choosephoto"),
                        onPressed: () => chooseFile(Picture.Car),
                        backgroundColor: kPrimaryColor,
                      ),
                      Container(height: 20),
                      RoundedInputField(
                        controller: _textFieldController,
                        hintText: getTranslated(context, "whatiscarmodel"),
                        icon: Icons.car_repair,
                        onSaved: (value) {
                          _carModel = value.trim();
                        },
                      ),
                      Container(height: 20),
                      getTitle(
                          title: getTranslated(context, "fillpaymentinfo"),
                          fontSize: 15),
                      CreditCardWidget(
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        cardBgColor: kPrimaryColor,
                        cardType: CardType.visa,
                      ),
                      Column(
                        children: [
                          CreditCardForm(
                            cvvValidationMessage: "validated",
                            formKey: formKey,
                            obscureCvv: true,
                            obscureNumber: true,
                            cardNumber: cardNumber,
                            cvvCode: cvvCode,
                            cardHolderName: cardHolderName,
                            expiryDate: expiryDate,
                            themeColor: kPrimaryColor,
                            cardNumberDecoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Card Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                            ),
                            expiryDateDecoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expired Date',
                              hintText: 'XX/XX',
                            ),
                            cvvCodeDecoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'CVV',
                              hintText: 'XXX',
                            ),
                            cardHolderDecoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Card Holder',
                            ),
                            onCreditCardModelChange: onCreditCardModelChange,
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: getTitle(
                            title: getTranslated(context, "agree"),
                            fontSize: 14),
                        value: agree,
                        onChanged: (newValue) {
                          setState(() {
                            agree = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                      Center(
                        child: CustomElevatedButton(
                          title: getTranslated(context, "sendreq"),
                          onPressed: _image.containsValue(null)
                              ? () {
                                  ReturnMessage.fail(context,
                                      getTranslated(context, "uploaderror"));
                                }
                              : uploadFile,
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

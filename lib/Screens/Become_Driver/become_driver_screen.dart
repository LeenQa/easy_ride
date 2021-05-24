import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Home/home_screen.dart';
import 'package:easy_ride/components/custom_container.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
                     ReturnMessage.success(
                          context, getTranslated(context, "successfulreq"));
                      setState(() {
                        _image.clear();
                        _textFieldController.clear();
                        _textFieldController2.clear();
                        _textFieldController3.clear();
                        _textFieldController4.clear();
                        cardNumber = '';
                        expiryDate = '';
                        cardHolderName = '';
                        cvvCode = '';
                      });
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routeName);
                    } else if (count == 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.orange,
                        content: getTitle(
                            title: getTranslated(context, "pleasewait")),
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
                      CustomContainer(
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
                              onPressed: () =>
                                  chooseFile(Picture.DriverLicense),
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
                              onPressed: () =>
                                  chooseFile(Picture.DriverIdentity),
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
                              hintText:
                                  getTranslated(context, "whatiscarmodel"),
                              icon: Icons.car_repair,
                              onSaved: (value) {
                                _carModel = value.trim();
                              },
                            ),
                          ],
                        ),
                      ),
                      CustomContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 20),
                            getTitle(
                                title:
                                    getTranslated(context, "fillpaymentinfo"),
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
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600),
                            ),
                            Column(
                              children: [
                                CreditCardForm(
                                  cvvValidationMessage:
                                      getTranslated(context, "validcvv"),
                                  dateValidationMessage:
                                      getTranslated(context, "validdate"),
                                  numberValidationMessage:
                                      getTranslated(context, "validcardnumber"),
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
                                      errorMaxLines: 3,
                                      hintStyle: TextStyle(fontSize: 13),
                                      labelStyle: TextStyle(fontSize: 13)),
                                  expiryDateDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Expired Date',
                                    hintText: 'XX/XX',
                                    errorMaxLines: 3,
                                    hintStyle: TextStyle(fontSize: 13),
                                    labelStyle: TextStyle(fontSize: 13),
                                  ),
                                  cvvCodeDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'CVV',
                                    hintText: 'XXX',
                                    errorMaxLines: 3,
                                    hintStyle: TextStyle(fontSize: 13),
                                    labelStyle: TextStyle(fontSize: 13),
                                  ),
                                  cardHolderDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Card Holder',
                                    labelStyle: TextStyle(fontSize: 13),
                                  ),
                                  onCreditCardModelChange:
                                      onCreditCardModelChange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: getTitle(
                          title: "Note: EasyRide takes 10% of every ride!",
                        ),
                      ),
                      CheckboxListTile(
                        title: GestureDetector(
                          onTap: _launch,
                          child: getTitle(
                              title: getTranslated(context, "agree"),
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                        ),
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

  Future<void> _launch() async {
    const url =
        'https://www.freeprivacypolicy.com/live/ff404587-6ac6-4189-a01e-af08e2ff5a6b';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}

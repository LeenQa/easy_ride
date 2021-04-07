import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
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

  Future chooseFile(Picture picture) async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image.update(picture, (value) => value = image);
      });
    });
  }

  Future uploadFile() async {
    List<String> pictures = [];
    print("entered here");
    _image.forEach((key, value) async {
      Reference storageReference;
      switch (key) {
        case Picture.DriverLicense:
          storageReference = FirebaseStorage.instance.ref().child(
              'becomeadriver/driverlicence/${Path.basename(value.path)}}');
          break;
        case Picture.CarLicense:
          storageReference = FirebaseStorage.instance
              .ref()
              .child('becomeadriver/carlicense/${Path.basename(value.path)}}');
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
        storageReference.getDownloadURL().then((fileURL) {
          _uploadedFileURL = fileURL;
          pictures.add(fileURL);
        });
      });
    });
    print(pictures.toString());
    await FirebaseFirestore.instance.collection('drivers').doc(uid).set({
      'user': user.email,
      'carModel': "wtvr",
      'pictures': pictures,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitle(
            title: getTranslated(context, 'bcmadriver'),
            color: kPrimaryColor,
            fontSize: 20),
        backgroundColor: Colors.white,
      ),
      body: Padding(
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
              _image[Picture.DriverLicense] == null
                  ? CustomElevatedButton(
                      title: "Choose photo",
                      onPressed: () => chooseFile(Picture.DriverLicense),
                      backgroundColor: kPrimaryColor,
                    )
                  : Container(height: 20),
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
              _image[Picture.CarLicense] == null
                  ? CustomElevatedButton(
                      title: "Choose photo",
                      onPressed: () => chooseFile(Picture.CarLicense),
                      backgroundColor: kPrimaryColor,
                    )
                  : Container(height: 20),
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
              _image[Picture.CarInsurance] == null
                  ? CustomElevatedButton(
                      title: "Choose photo",
                      onPressed: () => chooseFile(Picture.CarInsurance),
                      backgroundColor: kPrimaryColor,
                    )
                  : Container(height: 20),
              getTitle(
                  title: 'Upload a picture of your identity', fontSize: 15),
              _image[Picture.DriverIdentity] != null
                  ? Image.file(
                      File(_image[Picture.DriverIdentity].path),
                      height: 100,
                      width: 100,
                    )
                  : Container(height: 20),
              _image[Picture.DriverIdentity] == null
                  ? CustomElevatedButton(
                      title: "Choose photo",
                      onPressed: () => chooseFile(Picture.DriverIdentity),
                      backgroundColor: kPrimaryColor,
                    )
                  : Container(height: 20),
              getTitle(title: 'Upload a picture of your car', fontSize: 15),
              _image[Picture.Car] != null
                  ? Image.file(
                      File(_image[Picture.Car].path),
                      height: 100,
                      width: 100,
                    )
                  : Container(height: 20),
              _image[Picture.Car] == null
                  ? CustomElevatedButton(
                      title: "Choose photo",
                      onPressed: () => chooseFile(Picture.Car),
                      backgroundColor: kPrimaryColor,
                    )
                  : Container(height: 20),

              _image != null
                  ? RaisedButton(
                      child: Text('Clear Selection'),
                      //onPressed: (clearSelection),
                    )
                  : Container(height: 20),
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
                  onPressed: _image.containsValue(null) ? null : uploadFile,
                  backgroundColor: kPrimaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Home/home_screen.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ProfilePicScreen extends StatefulWidget {
  final String id;
  static const String routeName = '/profilepicscreen';

  const ProfilePicScreen({this.id});
  @override
  _ProfilePicScreenState createState() => _ProfilePicScreenState();
}

class _ProfilePicScreenState extends State<ProfilePicScreen> {
  File _image;
  final picker = ImagePicker();
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _showSelectionDialog();
                },
                child: Container(
                  height: 150,
                  width: 150,
                  child: _image == null
                      ? Image.asset(
                          'assets/images/user.png') // set a placeholder image when no photo is set
                      : Image.file(_image),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Please select your profile photo',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method for sending a selected or taken photo to the EditPage
  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Reference storageReference;
        storageReference = FirebaseStorage.instance
            .ref()
            .child('profilepics/${Path.basename(_image.path)}}');
        UploadTask uploadTask = storageReference.putFile(File(_image.path));
        await uploadTask.whenComplete(() {
          print('File Uploaded');
          storageReference.getDownloadURL().then((fileURL) async {
            _uploadedFileURL = fileURL;
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.id)
                .update({
              'avatarUrl': _uploadedFileURL,
            });
          });
        });

        Navigator.pushNamed(context, ProfileScreen.routeName);
      } else
        print('No photo was selected or taken');
    });
  }

  /// Selection dialog that prompts the user to select an existing photo or take a new one
  Future _showSelectionDialog() async {
    await showDialog(
      builder: (context) => SimpleDialog(
        title: Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text('Take a photo'),
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

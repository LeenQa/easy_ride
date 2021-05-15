import 'package:easy_ride/Assistants/requestAssistant.dart';
import 'package:easy_ride/Screens/Home/home_screen.dart';
import 'package:easy_ride/Screens/Signup/components/field_validation.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/components/keys.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/components/rounded_password_field.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/place_prediction.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Login/login_screen.dart';
import 'package:easy_ride/Screens/Signup/components/background.dart';
import 'package:easy_ride/Screens/Signup/components/or_divider.dart';
import 'package:easy_ride/Screens/Signup/components/social_icon.dart';
import 'package:easy_ride/components/already_have_an_account_acheck.dart';
import 'package:easy_ride/components/rounded_button.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import 'location_prediction_tile.dart';

class SingupBody extends StatefulWidget {
  final void Function(
    User user,
  ) signupSubmit;
  final bool _isLoading;
  SingupBody(this.signupSubmit, this._isLoading);
  @override
  _SingupBodyState createState() => _SingupBodyState();
}

List<PlacePrediction> userLocationPredictionList = [];
TextEditingController userLocationController = TextEditingController();

class _SingupBodyState extends State<SingupBody> {
  User _user = User();
  final _formKey = GlobalKey<FormState>();

  void _trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.signupSubmit(_user);
      Navigator.of(ctx).pushNamed(
        LoginScreen.routeName,
      );
    }
  }

  callback() {
    setState(() {
      userLocationPredictionList = [];
      userLocationController.text =
          Provider.of<Address>(context, listen: false).userLocation.placeName;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _passConf = '';
    _user = User();
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.07),
              Text(
                getTranslated(context, 'signup'),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              ClipRRect(
                child: Image.asset(
                  "assets/icons/EZ.png",
                  height: size.height * 0.2,
                ),
                borderRadius: BorderRadius.circular(120),
              ),
              SizedBox(height: size.height * 0.02),
              RoundedInputField(
                icon: Icons.person,
                hintText: getTranslated(context, 'firstname'),
                onSaved: (value) {
                  _user.firstName = value.trim();
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              RoundedInputField(
                icon: Icons.person,
                hintText: getTranslated(context, 'lastname'),
                onSaved: (value) {
                  _user.lastName = value.trim();
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              RoundedInputField(
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                hintText: getTranslated(context, 'email'),
                onSaved: (value) {
                  _user.email = value.trim();
                },
                textCapitalization: TextCapitalization.none,
              ),
              RoundedInputField(
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                hintText: getTranslated(context, 'phone'),
                onSaved: (value) {
                  _user.phone = int.parse(value.trim());
                },
                textCapitalization: TextCapitalization.none,
              ),
              RoundedPasswordField(
                hintText: getTranslated(context, 'password'),
                validator: (value) {
                  var check = FieldValidation.validatePassword(value, context);
                  if (check == null) {
                    _passConf = value;
                  }
                  return check;
                },
                onSaved: (value) {
                  _user.password = value.trim();
                },
              ),
              RoundedPasswordField(
                hintText: getTranslated(context, 'confirmpass'),
                validator: (value) {
                  if (value.isEmpty) {
                    return getTranslated(context, 'fillemptyfields');
                  } else if (_passConf != value) {
                    return getTranslated(context, 'passwordsnotmatch');
                  } else
                    return null;
                },
                onSaved: (value) => _passConf = value,
              ),
              RoundedInputField(
                icon: Icons.location_on,
                hintText: getTranslated(context, 'location'),
                onSaved: (value) {
                  _user.location = value.trim();
                },
                onChanged: (value) {
                  findLocation(value);
                },
                controller: userLocationController,
                margin: 0,
                radius: (userLocationPredictionList.length > 0 ? 0 : null),
                textCapitalization: TextCapitalization.sentences,
              ),
              (userLocationPredictionList.length > 0)
                  ? Padding(
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(29),
                              bottomRight: Radius.circular(29),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0)),
                        ),
                        child: ListView.separated(
                            padding: EdgeInsets.all(5),
                            itemBuilder: (context, index) {
                              //return Text("data");
                              return PredictionTile(
                                  placePrediction:
                                      userLocationPredictionList[index],
                                  callback: callback);
                            },
                            separatorBuilder: (BuildContext context,
                                    int index) =>
                                Divider(
                                  indent:
                                      MediaQuery.of(context).size.width * 0.1,
                                  endIndent:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                            itemCount: userLocationPredictionList.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics()),
                      ),
                    )
                  : Container(),
              if (widget._isLoading)
                CircularProgressIndicator(
                  backgroundColor: kPrimaryColor,
                ),
              if (!widget._isLoading)
                RoundedButton(
                  text: getTranslated(context, 'signup'),
                  press: () => _trySubmit(context),
                ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                  SizedBox(height: size.height * 0.19),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void findLocation(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:PS";

      var response =
          await RequestAssistant.getRequest(Uri.parse(autoCompleteUrl));

      if (response == "Failed.") {
        return;
      }

      if (response["status"] == "OK") {
        var predictions = response["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();
        setState(() {
          userLocationPredictionList = placesList;
        });
      }
      print(response);
    }
  }
}

import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'profile')),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 4,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.width * 0.55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://scontent.fjrs4-1.fna.fbcdn.net/v/t1.0-9/62531188_10219369477333828_8288775080092106752_o.jpg?_nc_cat=105&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=Ozby0D4dufgAX-qyJgg&_nc_ht=scontent.fjrs4-1.fna&oh=5a191e65576fa58a4185ddfeb1319f2a&oe=607A7E23'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              'Alex Dukmak',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      minLeadingWidth: 1,
                      minVerticalPadding: 1,
                      leading: Icon(
                        Icons.verified_rounded,
                        color: Colors.lightBlue,
                      ),
                      title: Text(
                        "Verified Driver",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Text(
                      "Email: alex@gmail.com",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "Phone Number: 4324324",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
            Card(),
          ],
        ),
      ),
    );
  }
}

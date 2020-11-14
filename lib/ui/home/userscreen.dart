import 'dart:ui';

import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key key, this.title, this.userStore}) : super(key: key);
  final String title;
  final UserStore userStore;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with TickerProviderStateMixin {
  AnimationController _rippleAnimationController;
  bool loggedIn = false;
  @override
  void initState() {
    super.initState();
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );
    getUserLogin();
  }

  void getUserLogin() async {
    var sharePerf = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = sharePerf.getBool(Preferences.is_logged_in) || false;
    });
    if (loggedIn == true) {
      if (widget.userStore.user == null) widget.userStore.getUser();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'خانه',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "جست و جو های اخیر",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topRight,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      trailing: Icon(Icons.delete),
                      title: Text('Sun'),
                    ),
                    ListTile(
                      trailing: Icon(Icons.delete),
                      title: Text('Moon'),
                    ),
                    ListTile(
                      trailing: Icon(Icons.delete),
                      title: Text('Star'),
                    ),
                  ],
                )),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image: new AssetImage("assets/images/bg10.png"),
                fit: BoxFit.fill,
              )),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: Text('ارسال آگهی'),
                // icon: Icon(Icons.send),
                backgroundColor: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

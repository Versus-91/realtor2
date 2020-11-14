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
      body: Stack(
        children: [
          // Image.asset("assets/images/bg10.png"),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              right: 10,
              left: 10,
            ),
            child: Column(
              children: [
                Container(
                 
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                 
                  alignment: Alignment.topRight,
                  child: Text(
                    "جست و جو های اخیر",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15),
        child: InkWell(
          onTap: () {},
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xffF77E78), Color(0xffF5150A)])),
            child: Text(
              'افزودن آگهی',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/home/userhomelist.dart';
import 'package:boilerplate/ui/home/recommendations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key key, this.title, this.userStore, this.postStore})
      : super(key: key);
  final String title;
  final UserStore userStore;
  final PostStore postStore;
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool loggedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLogin();
  }

  void getUserLogin() async {
    var sharePerf = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = sharePerf.getBool(Preferences.is_logged_in) || false;
    });
    if (loggedIn == true) {
      if (widget.userStore.user == null) widget.userStore.getUser();
      widget.postStore.getUserPosts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        if (loggedIn == true) ...[
          Observer(builder: (context) {
            return widget.userStore.user != null
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 20, top: 30, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: widget.userStore.user.email,
                                      style: TextStyle(
                                          fontFamily: 'ConcertOne-Regular',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('آگهی‏‏ های من'),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 30,
                          child: ClipOval(
                              child: Image.asset(
                            'assets/images/animal.png',
                            // Photo from https://unsplash.com/photos/QXevDflbl8A
                            fit: BoxFit.cover,
                            width: 55.0,
                            height: 55.0,
                          )),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          }),
          UserHomeList(store: widget.postStore)
        ],
        if (loggedIn == false)
          InkWell(
            onTap: () => {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.register, (Route<dynamic> route) => false)
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
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
                  'ثبت نام',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 25, bottom: 40, right: 25),
          child: Text(
            'جست و جوهای اخیر',
            style: TextStyle(
                fontFamily: 'ConcertOne-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
        RecommendedPlace(store: widget.postStore),
        if (loggedIn == false)
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    ));
  }
}

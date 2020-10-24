import 'package:boilerplate/models/post/post.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.post});
  final Post post;
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
                color: Color(0xffff772e),
                height: 290.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 70,
                      child: ClipOval(
                          child: Image.asset(
                        'assets/images/pool.png',
                        fit: BoxFit.cover,
                        width: 55.0,
                        height: 55.0,
                      )),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: 250, left: 20, right: 20),
              child: Container(
                  height: 70.0,
                  width: MediaQuery.of(context).size.width - 20.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8,
                            0.0), // 10% of the width, so there are ten blinds.
                        colors: [
                          const Color(0xffee0000),
                          const Color(0xffeeee00)
                        ], // red to yellow
                      ),
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1000.0,
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2.0)
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'پنل کاربری',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: const Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 60, bottom: 20, right: 14, left: 14),
          child: Text(
            'آگهی های من',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'ConcertOne-Regular'),
          ),
        ),
      ],
    ));
  }
}

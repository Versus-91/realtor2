import 'package:boilerplate/main.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../routes.dart';

class MySplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: Text(
        'خوش آمدید.',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      navigateAfterFuture: navigate(),
      image: Image.asset('assets/icons/splash.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 150.0,
      loaderColor: Colors.redAccent,
    );
  }

  Future<String> navigate() async {
    return Future.delayed(Duration(seconds: 2), () {
      return appComponent.getRepository().isLoggedIn.then((val) {
        return val == true ? Routes.home : Routes.login;
      });
    });
  }
}

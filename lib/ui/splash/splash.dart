import 'package:boilerplate/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

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
      seconds: 5,
      navigateAfterSeconds: HomeScreen(),
      image: Image.asset('assets/icons/splash.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 150.0,
      loaderColor: Colors.redAccent,
    );
  }
}

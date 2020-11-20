// import 'package:boilerplate/ui/firstPage/firstpage.dart';
import 'package:boilerplate/ui/authorization/login/login.dart';
import 'package:boilerplate/ui/authorization/signup/register.dart';
import 'package:boilerplate/ui/map/map.dart';
import 'package:boilerplate/ui/post/createPost.dart';
import 'package:boilerplate/ui/post/post.dart';
import 'package:flutter/material.dart';
import 'ui/home/home.dart';
import 'ui/splash/splash.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String search = '/search';
  static const String post = '/post';
  static const String map = '/map';

  static const String createpost = '/createpost';

  // static const String firsapp = '/firsapp';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => MySplashScreen(),
    login: (BuildContext context) => LoginPage(),
    home: (BuildContext context) => HomeScreen(),
    register: (BuildContext context) => RegisterScreen(),
    post: (BuildContext context) => PostScreen(),
    map: (BuildContext context) => MapScreen(),
    createpost: (BuildContext context) => CreatePostScreen(),
  };
}

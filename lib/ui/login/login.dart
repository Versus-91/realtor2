import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/ui/login/blaziercontainer.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes.dart';
import 'custom_button.dart';
import 'custom_input_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formStore = FormStore(appComponent.getRepository());
  final _userNameController = TextEditingController();
  final _passwordNameController = TextEditingController();

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: CustomButton(
        color: Colors.red,
        textColor: kWhite,
        text: 'ورود',
        onPressed: () {
          _formStore.login().then((value) {
            if (value == true) {
              SharedPreferences.getInstance().then((prefs) {
                prefs.setBool(Preferences.is_logged_in, true);
                print(
                    "is logged in ${prefs.getBool(Preferences.is_logged_in)}");
              });
            }
          });
        },
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('یا'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget navigate(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => true);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.3, color: Colors.grey),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('G',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.3, color: Colors.grey),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('ورود با جیمیل',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.home);
                  },
                  icon: Icon(Icons.keyboard_arrow_right),
                  label: Text("رد شدن", style: TextStyle(color: Colors.blue))),
            ),
            Row(
              children: [
                Text(
                  'آیا ثبت نام نکرده اید؟',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10,
                ),
                RichText(
                    text: TextSpan(
                        text: 'ثبت نام',
                        style: TextStyle(
                            color: Color(0xfff79c4f),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Future.delayed(Duration(milliseconds: 0), () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.register,
                                  (Route<dynamic> route) => false);
                            });
                          })),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'M',
          style: TextStyle(color: Colors.blue, fontSize: 20),
          children: [
            TextSpan(
              text: 'y Ho',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'me',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  Column(
                    children: <Widget>[
                      CustomInputField(
                        store: _formStore.setUserId,
                        controller: _userNameController,
                        isEmail: true,
                        label: 'نام کاربری/ایمیل',
                        prefixIcon: Icons.person,
                        formStore: _formStore,
                        obscureText: false,
                      ),

                      CustomInputField(
                        store: _formStore.setPassword,
                        isEmail: false,
                        controller: _passwordNameController,
                        label: 'رمز ورود',
                        formStore: _formStore,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "رمز خود را فراموش کرده اید؟",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 12),
                              ),
                              //Checkbox
                              Row(
                                children: [
                                  Text(
                                    "مرا به خاطر بسپار",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.blue,
                                    checkColor: Colors.white,
                                    value: true,
                                  ),
                                ],
                              ),
                            ],
                          )),
                      // FadeSlideTransition(
                      //   animation: widget.animation,
                      //   additionalOffset: space,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [

                      //       //Text
                      //     ],
                      //   ),
                      // ),

                      Observer(
                        builder: (context) {
                          return _formStore.success
                              ? navigate(context)
                              : _showErrorMessage(
                                  _formStore.errorStore.errorMessage);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _submitButton(),
                  _divider(),
                  _facebookButton(),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Observer(
            builder: (context) {
              return _formStore.success
                  ? navigate(context)
                  : _showErrorMessage('_formStore.errorStore.errorMessage');
            },
          )
        ],
      ),
    ));
  }
}

import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/notifications/notification_manageer.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/ui/authorization/login/blaziercontainer.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';
import 'custom_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;
  final formStore = FormStore(appComponent.getRepository());
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userNameController = TextEditingController();
  final _passwordNameController = TextEditingController();
  PushNotificationsManager _firebaseService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _firebaseService = Provider.of<PushNotificationsManager>(context);
  }

  Widget _submitButton() {
    return Container(
      height: 45,
      child: CustomButton(
        color: Colors.red,
        textColor: kWhite,
        text: AppLocalizations.of(context).translate('login_btn_sign_in'),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          widget.formStore.login().then((value) async {
            if (value == true) {
              var token = await _firebaseService.fcmToken;
              await appComponent.getRepository().saveNotification(token);
            }
          });
        },
      ),
    );
  }

  // Widget _divider() {
  //   return Container(
  //     height: 20,
  //     margin: EdgeInsets.symmetric(vertical: 5),
  //     child: Row(
  //       children: <Widget>[
  //         SizedBox(
  //           width: 10,
  //         ),
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 10),
  //             child: Divider(
  //               thickness: 1,
  //             ),
  //           ),
  //         ),
  //         Text('یا'),
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 10),
  //             child: Divider(
  //               thickness: 1,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: 10,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget navigate(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
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

  Widget _title() {
    return Container(
      height: (MediaQuery.of(context).size.height) * .06,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'ورود',
            style: TextStyle(color: Colors.blue, fontSize: 30),
            children: [
              TextSpan(
                text: ' به ',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'حساب',
                style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .25,
                right: -MediaQuery.of(context).size.width * .3,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 20),
                  Container(
                    height: height / 1.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Observer(builder: (context) {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('user_email'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                    controller: _userNameController,
                                    onChanged: (value) {
                                      widget.formStore.setUsernameOrEmail(
                                          _userNameController.text);
                                    },
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        suffixIcon:
                                            _userNameController.text.length > 0
                                                ? IconButton(
                                                    onPressed: () {
                                                      _userNameController
                                                          .clear();
                                                      widget.formStore
                                                          .setUsernameOrEmail(
                                                              _passwordNameController
                                                                  .text);
                                                    },
                                                    icon: Icon(Icons.clear),
                                                  )
                                                : SizedBox.shrink(),
                                        errorText: widget.formStore
                                            .formErrorStore.usernameOrEmail,
                                        border: InputBorder.none,
                                        fillColor: Colors.grey[300],
                                        filled: true)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('user_password'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                    controller: _passwordNameController,
                                    onChanged: (value) {
                                      widget.formStore.setPassword(
                                          _passwordNameController.text);
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        suffixIcon: _passwordNameController
                                                    .text.length >
                                                0
                                            ? IconButton(
                                                onPressed: () {
                                                  _passwordNameController
                                                      .clear();
                                                  widget.formStore.setPassword(
                                                      _passwordNameController
                                                          .text);
                                                },
                                                icon: Icon(Icons.clear),
                                              )
                                            : SizedBox.shrink(),
                                        errorText: widget
                                            .formStore.formErrorStore.password,
                                        border: InputBorder.none,
                                        fillColor: Colors.grey[300],
                                        filled: true)),
                                SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('login_btn_forgot_password'),
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _submitButton(),
                                // _divider(),
                                // _facebookButton(),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Observer(
                    builder: (context) {
                      return widget.formStore.success
                          ? navigate(context)
                          : _showErrorMessage(
                              widget.formStore.errorStore.errorMessage);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.home);
                  },
                  icon: Icon(Icons.keyboard_arrow_right),
                  label: Text(AppLocalizations.of(context).translate('skip'),
                      style: TextStyle(color: Colors.blue))),
            ),
            Positioned(
                bottom: 10,
                left: 20,
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('login_btn_Register'),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    VerticalDivider(),
                    RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)
                                .translate('Register'),
                            style: TextStyle(
                                color: Color(0xfff79c4f),
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Future.delayed(Duration(milliseconds: 0), () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.register,
                                      (Route<dynamic> route) => true);
                                });
                              })),
                  ],
                )),
            Observer(
              builder: (context) {
                return Visibility(
                  visible: widget.formStore.loading,
                  child: CustomProgressIndicatorWidget(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userNameController.dispose();
    _passwordNameController.dispose();
    super.dispose();
  }
}

import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/ui/authorization/login/blaziercontainer.dart';
import 'package:boilerplate/ui/authorization/login/login.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _familyController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _amlakNameController = TextEditingController();
  TextEditingController _registerIdController = TextEditingController();
  //stores:---------------------------------------------------------------------
  ThemeStore _themeStore;
  // SingingCharacter _character = SingingCharacter.amlakuser;

  //focus node:-----------------------------------------------------------------
  FocusNode _nameFocusNode;
  FocusNode _familyFocusNode;
  FocusNode _usernameFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _numberFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _confrimpasswordFocusNode;
  // FocusNode _submitFocusNode;

  //stores:---------------------------------------------------------------------
  final _formStore = FormStore(appComponent.getRepository());

  @override
  void initState() {
    super.initState();

    _nameFocusNode = FocusNode();
    _familyFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _numberFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confrimpasswordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _themeStore = Provider.of<ThemeStore>(context);
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Text(AppLocalizations.of(context).translate('back'),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Icon(Icons.keyboard_arrow_left, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('user_name'),
          focusNode: _nameFocusNode,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_familyFocusNode);
          },
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.account_circle,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _nameController,
          onChanged: (value) {
            _formStore.setName(_nameController.text);
          },
          errorText: _formStore.formErrorStore.name,
        );
      },
    );
  }

  Widget _buildFamilyField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('family'),
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.account_box,
          focusNode: _familyFocusNode,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_usernameFocusNode);
          },
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _familyController,
          onChanged: (value) {
            _formStore.setFamily(_familyController.text);
          },
          errorText: _formStore.formErrorStore.family,
        );
      },
    );
  }

  Widget _buildEmailField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('user_email'),
          inputType: TextInputType.emailAddress,
          icon: Icons.email,
          padding: EdgeInsets.only(top: 16.0),
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          focusNode: _emailFocusNode,
          onChanged: (value) {
            _formStore.setUserLogin(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_numberFocusNode);
          },
          errorText: _formStore.formErrorStore.userEmail,
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('user_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: _formStore.formErrorStore.password,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_confrimpasswordFocusNode);
          },
          onChanged: (value) {
            _formStore.setPassword(_passwordController.text);
          },
        );
      },
    );
  }

  Widget _buildNumberField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          inputType: TextInputType.number,
          hint: AppLocalizations.of(context).translate('user_Number'),
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.phone_android,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _numberController,
          focusNode: _numberFocusNode,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          onChanged: (value) {
            _formStore.setNumber(value.toString());
          },
          errorText: _formStore.formErrorStore.number,
        );
      },
    );
  }

  // _showSuccessMessage(String message) {
  //   Future.delayed(Duration(milliseconds: 0), () {
  //     if (message != null && message.isNotEmpty) {
  //       FlushbarHelper.createSuccess(
  //         message: message,
  //         title: AppLocalizations.of(context).translate('Register'),
  //         duration: Duration(seconds: 3),
  //       )..show(context).then((value) {
  //           Future.delayed(Duration(milliseconds: 0), () {
  //             Navigator.of(context).pushNamedAndRemoveUntil(
  //                 Routes.home, (Route<dynamic> route) => false);
  //           });
  //         });
  //     }
  //   });

  //   return SizedBox.shrink();
  // }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (!_formStore.formErrorStore.hasErrorsInRegister) {
          _formStore.register().then((result) {
            if (result == true) {
              _formStore.setUserName(_formStore.username);
              _formStore.setPassword(_formStore.password);
              _formStore.login().then((value) {
                if (value == true) {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool(Preferences.is_logged_in, true);
                  });

                  _formStore
                      .changePhoneNumber(_numberController.text)
                      .then((value) async {
                    var result = await Navigator.of(context).pushNamed(
                        Routes.phoneNumberVerificationCode,
                        arguments: {'phone': _numberController.text});
                    if (result != null) {
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.home, (Route<dynamic> route) => false);
                      });
                    }
                  }).catchError((error) {
                    print(error);
                    _showErrorMessage(
                      "خطا در تایید شماره همراه",
                    );
                  });
                  // _showSuccessMessage(
                  //     AppLocalizations.of(context).translate('succes_signup'));
                } else {
                  _showErrorMessage(
                      AppLocalizations.of(context).translate('error_in_login'));
                }
              });
            } else {
              _showErrorMessage(
                  AppLocalizations.of(context).translate('error_in_submit'));
            }
          });
        } else {
          _showErrorMessage(
              AppLocalizations.of(context).translate('error_in_form_inputs'));
        }
      },
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
          AppLocalizations.of(context).translate('Register'),
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('btn_Register'),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              AppLocalizations.of(context).translate('Register'),
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'خو',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ش آ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'مدید',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .25,
              right: -MediaQuery.of(context).size.width * .30,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .15),
                    _title(),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        _buildNameField(),
                        _buildFamilyField(),
                        _buildEmailField(),
                        _buildNumberField(),
                        _buildPasswordField(),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .02),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
            Observer(
              builder: (context) {
                return _formStore.loading == true
                    ? Center(child: CustomProgressIndicatorWidget())
                    : SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _nameController.dispose();
    _familyController.dispose();
    _userNameController.dispose();
    _numberController.dispose();
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _amlakNameController.dispose();
    _registerIdController.dispose();
    super.dispose();
  }
}

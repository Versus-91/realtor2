import 'package:boilerplate/main.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/ui/authorization/login/blaziercontainer.dart';
import 'package:boilerplate/ui/authorization/login/login.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            Icon(Icons.keyboard_arrow_left, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildUserNameField() {
    return Observer(
      builder: (context) {
        return TextField(
          focusNode: _usernameFocusNode,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_nameFocusNode);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.black54,
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true,
            // contentPadding: EdgeInsets.only(top: 16.0),
            errorText: _formStore.formErrorStore.username,
            hintText: AppLocalizations.of(context).translate('user_name'),
            suffixIcon: _userNameController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      _userNameController.clear();
                      _formStore.setUserName(_userNameController.text);
                    },
                    icon: Icon(Icons.clear),
                  )
                : SizedBox.shrink(),
          ),
          controller: _userNameController,
          onChanged: (value) {
            _formStore.setUserName(_userNameController.text);
          },
        );
      },
    );
  }

  Widget _buildFamilyField() {
    return Observer(
      builder: (context) {
        return TextField(
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('family'),
            prefixIcon: Icon(
              Icons.account_tree,
              color: Colors.black54,
            ),
            errorText: _formStore.formErrorStore.family,
            fillColor: Color(0xfff3f3f4),
            filled: true,
            suffixIcon: _familyController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      _familyController.clear();
                      _formStore.setFamily(_familyController.text);
                    },
                    icon: Icon(Icons.clear),
                  )
                : SizedBox.shrink(),
          ),
          focusNode: _familyFocusNode,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          },
          controller: _familyController,
          onChanged: (value) {
            _formStore.setFamily(_familyController.text);
          },
        );
      },
    );
  }

  Widget _buildNameField() {
    return Observer(
      builder: (context) {
        return TextField(
          decoration: InputDecoration(
            fillColor: Color(0xfff3f3f4),
            filled: true,
            suffixIcon: _nameController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      _nameController.clear();
                      _formStore.setName(_nameController.text);
                    },
                    icon: Icon(Icons.clear),
                  )
                : SizedBox.shrink(),
            hintText: AppLocalizations.of(context).translate('Name'),
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.black54,
            ),
            errorText: _formStore.formErrorStore.name,
          ),
          controller: _nameController,
          focusNode: _nameFocusNode,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_familyFocusNode);
          },
          onChanged: (value) {
            _formStore.setName(_nameController.text);
          },
        );
      },
    );
  }

  Widget _buildEmailField() {
    return Observer(
      builder: (context) {
        return TextField(
          decoration: InputDecoration(
            fillColor: Color(0xfff3f3f4),
            filled: true,
            suffixIcon: _userEmailController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      _userEmailController.clear();
                      _formStore.setEmail(_userEmailController.text);
                    },
                    icon: Icon(Icons.clear),
                  )
                : SizedBox.shrink(),
            hintText: AppLocalizations.of(context).translate('user_email'),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black54,
            ),
            errorText: _formStore.formErrorStore.email,
          ),
          keyboardType: TextInputType.emailAddress,
          controller: _userEmailController,
          focusNode: _emailFocusNode,
          onChanged: (value) {
            _formStore.setEmail(_userEmailController.text);
          },
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_numberFocusNode);
          },
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextField(
          decoration: InputDecoration(
            fillColor: Color(0xfff3f3f4),
            filled: true,
            suffixIcon: _passwordController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      _passwordController.clear();
                      _formStore.setPassword(_passwordController.text);
                    },
                    icon: Icon(Icons.clear),
                  )
                : SizedBox.shrink(),
            hintText: AppLocalizations.of(context).translate('user_password'),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black54,
            ),
            errorText: _formStore.formErrorStore.password,
          ),
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_confrimpasswordFocusNode);
          },
          obscureText: true,
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
        return TextField(
          decoration: InputDecoration(
            fillColor: Color(0xfff3f3f4),
            filled: true,
            suffixIcon: _numberController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      _numberController.clear();
                      _formStore.setNumber(_numberController.text);
                    },
                    icon: Icon(Icons.clear),
                  )
                : SizedBox.shrink(),
            hintText: AppLocalizations.of(context).translate('user_Number'),
            prefixIcon: Icon(
              Icons.phone_android,
              color: Colors.black54,
            ),
            errorText: _formStore.formErrorStore.number,
          ),
          keyboardType: TextInputType.number,
          controller: _numberController,
          focusNode: _numberFocusNode,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          onChanged: (value) {
            _formStore.setNumber(value.toString());
          },
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
        FocusScope.of(context).requestFocus(FocusNode());
        if (!_formStore.formErrorStore.hasErrorsInRegister) {
          _formStore.register().then((result) {
            if (result == true) {
              _formStore.setUsernameOrEmail(_formStore.userName);
              _formStore.setPassword(_formStore.password);
              _formStore.login().then((value) async {
                if (value == true) {
                  _formStore
                      .changePhoneNumber(_numberController.text)
                      .then((value) async {
                    var result = await Navigator.of(context).pushNamed(
                        Routes.phoneNumberVerificationCode,
                        arguments: {
                          'phone': _numberController.text,
                          'fromRegister': true
                        });
                    if (result != null) {
                      Future.delayed(Duration(milliseconds: 100), () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamedAndRemoveUntil(
                                Routes.home, (Route<dynamic> route) => false);
                      });
                    }
                  }).catchError((error) {
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamedAndRemoveUntil(
                              Routes.home, (Route<dynamic> route) => false);
                    });
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
              AppLocalizations.of(context).translate('login_btn_sign_in'),
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 15,
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
          style: TextStyle(
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
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                        _buildUserNameField(),
                        Observer(
                            builder: (_) => AnimatedOpacity(
                                child: const LinearProgressIndicator(),
                                duration: const Duration(milliseconds: 300),
                                opacity:
                                    _formStore.isUserCheckPending ? 1 : 0)),
                        SizedBox(
                          height: 16,
                        ),
                        _buildNameField(),
                        SizedBox(
                          height: 16,
                        ),
                        _buildFamilyField(),
                        SizedBox(
                          height: 16,
                        ),
                        _buildEmailField(),
                        Observer(
                            builder: (_) => AnimatedOpacity(
                                child: const LinearProgressIndicator(),
                                duration: const Duration(milliseconds: 300),
                                opacity: _formStore.isEmailPending ? 1 : 0)),
                        SizedBox(
                          height: 16,
                        ),
                        _buildNumberField(),
                        Observer(
                            builder: (_) => AnimatedOpacity(
                                child: const LinearProgressIndicator(),
                                duration: const Duration(milliseconds: 300),
                                opacity: _formStore.isNumberPending ? 1 : 0)),
                        SizedBox(
                          height: 16,
                        ),
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

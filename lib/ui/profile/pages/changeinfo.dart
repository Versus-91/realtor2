import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/authorization/login/custom_button.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChangeInfo extends StatefulWidget {
  @override
  _ChangeInfoState createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------
  UserStore _userStore;

  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  //text controllers:-----------------------------------------------------------

  TextEditingController _newNumberController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);

    if (!_userStore.loading && _userStore.user == null) _userStore.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('edite_info'),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.red,
      ),
      body: Observer(
        builder: (context) {
          return _userStore.loading == true
              ? Center(child: CircularProgressIndicator())
              : _buildBody();
        },
      ),
    );
  }

  // app bar methods:-----------------------------------------------------------

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(builder: (context) {
      if (_userStore.user != null) {
        _newNumberController.text = _userStore.user.phonenumber;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(children: [
              Divider(),
              Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 50,
                      child: TextField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.ltr,
                        controller: _newNumberController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.edit),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate('user_Number'),
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      text: AppLocalizations.of(context)
                          .translate('register_info'),
                      onPressed: () async {
                        _userStore
                            .changePhoneNumber(_newNumberController.text)
                            .then((value) async {
                          var result =
                              await Navigator.of(context, rootNavigator: true)
                                  .pushNamed(Routes.phoneNumberVerificationCode,
                                      arguments: {
                                'phone': _newNumberController.text
                              });
                          _newNumberController.text = result;
                        }).catchError((error) {
                          _showErrorMessage(
                            "خطا در تغییر شماره همراه",
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    _userStore.user.isPhoneNumberConfirmed
                        ? Icons.check_circle_outline
                        : Icons.radio_button_off_sharp,
                    color: _userStore.user.isPhoneNumberConfirmed
                        ? Colors.green
                        : Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text("تایید شده"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  suffix: IconButton(
                    icon: _obscureText == true
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: _toggle,
                  ),
                  labelText:
                      AppLocalizations.of(context).translate('old_password'),
                ),
                onChanged: (value) {
                  _userStore.setOldPassword(value.toString());
                },
                obscureText: _obscureText,
              ),

              SizedBox(
                height: 10,
              ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: FlatButton(
              //     onPressed: () {},
              //     child: Text(
              //       AppLocalizations.of(context)
              //           .translate('login_btn_forgot_password'),
              //       style: TextStyle(color: Colors.blue, fontSize: 10),
              //     ),
              //   ),
              // ),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  errorText: _userStore.userErrorStore.newPassword,
                  suffix: Icon(Icons.lock),
                  labelText:
                      AppLocalizations.of(context).translate('new_password'),
                ),
                onChanged: (value) {
                  _userStore.setNewPassword(value.toString());
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  suffix: Icon(Icons.lock),
                  errorText: _userStore.userErrorStore.confrimPassword,
                  // border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)
                      .translate('confirm_password'),
                ),
                onChanged: (value) {
                  _userStore.setConfirmPassword(value.toString());
                },
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: CustomButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  text: AppLocalizations.of(context).translate('register_info'),
                  onPressed: () async {
                    _userStore
                        .changePass(ChangePassword(
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                      confirmPassword: _confirmPasswordController.text,
                    ))
                        .then((value) async {
                      successMessage('رمز با موفقیت تغییر کرد.');
                      // _newNumberController.text = result;
                    }).catchError((error) {
                      if (error?.response?.data
                          .toString()
                          .contains("not match")) {
                        _showErrorMessage(
                          "رمز فعلی اشتباه وارد شده است.",
                        );
                      } else {
                        _showErrorMessage(
                          "خطا در تغییر رمز",
                        );
                      }
                    });
                  },
                ),
              ),
            ]),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
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

  Widget successMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () async {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createSuccess(
          message: message,
          title: AppLocalizations.of(context).translate('succes_send'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });
    return SizedBox.shrink();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

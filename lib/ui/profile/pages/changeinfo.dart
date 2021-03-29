import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/user/changuserinfo.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _familyController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();
  TextEditingController _newNumberController = TextEditingController();

  FocusNode _nameFocusNode;
  FocusNode _familyFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _numberFocusNode;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  //text controllers:-----------------------------------------------------------

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
    _newNumberController.text = _userStore.user.phonenumber;
    _nameController.text = _userStore.user.name;
    _familyController.text = _userStore.user.surname;
    _emailController.text = _userStore.user.email;
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
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
          backgroundColor: Colors.red,
        ),
        body: _buildBody());
  }

  // app bar methods:-----------------------------------------------------------

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(builder: (context) {
      if (_userStore.user != null) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  focusNode: _nameFocusNode,
                  validator: (value) {
                    if (value.length < 4) {
                      return 'طول نام باید بیش از 4 کاراکتر باشد';
                    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                        .hasMatch(value)) {
                      return "نامعتبر";
                    }
                    return null;
                  },
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.edit),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      //  when the TextFormField in unfocused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      //  when the TextFormField in focused
                    ),
                    border: UnderlineInputBorder(),
                    errorText: _userStore.userErrorStore.name,
                    suffix: Icon(Icons.person),
                    labelText: AppLocalizations.of(context).translate('Name'),
                  ),
                  onChanged: (value) {
                    FocusScope.of(context).requestFocus(_familyFocusNode);
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value.length < 4) {
                      return 'طول این فیلد باید بیش از 4 کاراکتر باشد';
                    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                        .hasMatch(value)) {
                      return "نامعتبر";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    FocusScope.of(context).requestFocus(_numberFocusNode);
                  },
                  focusNode: _familyFocusNode,
                  controller: _familyController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                    errorText: _userStore.userErrorStore.name,
                    // suffix: Icon(Icons.person_add_alt_1_outlined),
                    labelText: AppLocalizations.of(context).translate('family'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        child: TextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.ltr,
                          controller: _newNumberController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),

                            prefixIcon: Icon(Icons.edit),
                            // border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)
                                .translate('user_Number'),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: CustomButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          text:
                              AppLocalizations.of(context).translate('submit'),
                          onPressed: () async {
                            var snackBar =
                                Scaffold.of(context).showSnackBar(SnackBar(
                              // duration:  Duration(seconds: 4),
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Text(" درحال دریافت اطلاعات")
                                ],
                              ),
                            ));
                            _userStore
                                .changePhoneNumber(_newNumberController.text)
                                .then((value) async {
                              _alertDialog();

                              snackBar.close();
                            }).catchError((error) {
                              snackBar.close();
                              _showErrorMessage(
                                "خطا در سرور",
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      _userStore.user.isPhoneNumberConfirmed
                          ? Icons.check_circle_outline
                          : Icons.error,
                      color: _userStore.user.isPhoneNumberConfirmed
                          ? Colors.green
                          : Colors.red.withOpacity(1),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    _userStore.user.isPhoneNumberConfirmed
                        ? Text(
                            "تایید شده",
                          )
                        : Text("تایید نشده"),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        child: TextFormField(
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.edit),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            border: UnderlineInputBorder(),
                            suffix: Icon(
                              Icons.email,
                            ),
                            labelText:
                                AppLocalizations.of(context).translate('email'),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: CustomButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          text:
                              AppLocalizations.of(context).translate('submit'),
                          onPressed: () async {
                            var snackBar =
                                Scaffold.of(context).showSnackBar(SnackBar(
                              // duration:  Duration(seconds: 4),
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Text(" درحال دریافت اطلاعات")
                                ],
                              ),
                            ));
                            _userStore
                                .changeEmailAdderss(_emailController.text)
                                .then((value) async {
                              _alertDialog();

                              snackBar.close();
                            }).catchError((error) {
                              snackBar.close();
                              _showErrorMessage(
                                "خطا در سرور",
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      _userStore.user.isEmailConfirmed
                          ? Icons.check_circle_outline
                          : Icons.error,
                      color: _userStore.user.isEmailConfirmed
                          ? Colors.green
                          : Colors.red.withOpacity(1),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    _userStore.user.isEmailConfirmed
                        ? Text(
                            "تایید شده",
                          )
                        : Text("تایید نشده"),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: CustomButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    text:
                        AppLocalizations.of(context).translate('register_info'),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (_formKey.currentState.validate()) {
                        _userStore
                            .changeUserInfo(ChangeUserInfo(
                                name: _nameController.text,
                                surname: _familyController.text,
                                emailAddress: _emailController.text,
                                phonenumber: _newNumberController.text,
                                id: _userStore.user.id))
                            .then((value) async {
                          _userStore.getUser().then((res) {
                            Navigator.pop(context);
                          });
                          successMessage('اطلاعات با موفقیت تغییر کرد.');
                          // _newNumberController.text = result;
                        }).catchError((error) {
                          _showErrorMessage(
                            "خطا در تغییر اطلاعات",
                          );
                        });
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        );
      } else {
        return Container(
          width: 0,
          height: 0,
        );
      }
    });
  }

  void _alertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                title: Center(child: Text("کد تایید")),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        //  autovalidate: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'کد را وارد کنید';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: _verificationCodeController,
                        decoration: InputDecoration(
                          helperText: "کد تایید را وارد نمایید",
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.black45,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                actionsPadding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 5),
                actions: <Widget>[
                  registerButton(),
                  cancelButton(),
                ]);
          },
        );
      },
    );
  }

  Widget cancelButton() {
    return FlatButton(
        color: Colors.red,
        textColor: Colors.white,
        child: Text(AppLocalizations.of(context).translate('cancel')),
        onPressed: () async {
          Navigator.pop(context);
        });
  }

  Widget registerButton() {
    return FlatButton(
        color: Colors.green,
        textColor: Colors.white,
        child: Text(AppLocalizations.of(context).translate('register_info')),
        onPressed: () async {
          appComponent
              .getRepository()
              .verificationCodePhone(
                  _newNumberController.text, _verificationCodeController.text)
              .then((value) async {
            await _userStore.getUser();
            Navigator.pop(context);
          });
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
    _nameController.dispose();
    _familyController.dispose();
    _newNumberController.dispose();
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}

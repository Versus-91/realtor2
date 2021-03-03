import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------
  UserStore _userStore;

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _toggle3() {
    setState(() {
      _obscureText3 = !_obscureText3;
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
        actions: [
          FlatButton(
            child: Text("ذخیره"),
            onPressed: () async {
              _userStore
                  .changePass(ChangePassword(
                oldPassword: _oldPasswordController.text,
                newPassword: _newPasswordController.text,
                confirmPassword: _confirmPasswordController.text,
              ))
                  .then((value) async {
                successMessage('رمز با موفقیت تغییر کرد.');
                Navigator.of(context).pop();
                // _newNumberController.text = result;
              }).catchError((error) {
                if (error?.response?.data.toString().contains("not match")) {
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
          )
        ],
        title: Text(
          AppLocalizations.of(context).translate('chang_user_password'),
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
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      //  when the TextFormField in unfocused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      //  when the TextFormField in focused
                    ),
                    border: UnderlineInputBorder(),
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('login_btn_forgot_password'),
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      //  when the TextFormField in unfocused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      //  when the TextFormField in focused
                    ),
                    border: UnderlineInputBorder(),
                    errorText: _userStore.userErrorStore.newPassword,
                    suffix: IconButton(
                      icon: _obscureText2 == true
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: _toggle2,
                    ),
                    labelText:
                        AppLocalizations.of(context).translate('new_password'),
                  ),
                  onChanged: (value) {
                    _userStore.setNewPassword(value.toString());
                  },
                  obscureText: _obscureText2,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      //  when the TextFormField in unfocused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      //  when the TextFormField in focused
                    ),
                    border: UnderlineInputBorder(),
                    suffix: IconButton(
                      icon: _obscureText3 == true
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: _toggle3,
                    ),
                    errorText: _userStore.userErrorStore.confrimPassword,
                    // border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)
                        .translate('confirm_password'),
                  ),
                  onChanged: (value) {
                    _userStore.setConfirmPassword(value.toString());
                  },
                  obscureText: _obscureText3,
                ),
              ]),
            ),
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

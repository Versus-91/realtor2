import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/form/form_store.dart';
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
  String label;
  bool loading = false;
  var initialIndex = 0;
  final _formStore = FormStore(appComponent.getRepository());

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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('edite_info'),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.red,
      ),
      body: loading == true
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
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
          child: Column(children: [
            Divider(),
            Container(
              height: 55,
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
                  labelText:
                      AppLocalizations.of(context).translate('user_Number'),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: CustomButton(
                textColor: Colors.white,
                color: Colors.red,
                text: AppLocalizations.of(context).translate('change_number'),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  appComponent
                      .getRepository()
                      .addPhoneNumber(_newNumberController.text)
                      .then((value) async {
                    var result = await Navigator.of(context).pushNamed(
                        Routes.phoneNumberVerificationCode,
                        arguments: {'phone': _newNumberController.text});
                    setState(() {
                      loading = false;
                    });
                    // _newNumberController.text = result;
                  }).catchError((error) {
                    _showErrorMessage(
                      "خطا در تغییر شماره همراه",
                    );

                    setState(() {
                      loading = false;
                    });
                    print(error);
                  });
                },
              ),
            ),
            Divider(),
            Container(
              height: 55,
              child: TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  suffix: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate('old_password'),
                ),
                onChanged: (value) {
                  _userStore.setOldPassword(value.toString());
                },
              ),
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
            Container(
              height: 55,
              child: TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  suffix: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate('new_password'),
                ),
                onChanged: (value) {
                  _userStore.setNewPassword(value.toString());
                },
              ),
            ),
            Divider(),
            Container(
              height: 55,
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  suffix: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)
                      .translate('confirm_password'),
                ),
                onChanged: (value) {
                  _userStore.setConfirmPassword(value.toString());
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: CustomButton(
                color: Colors.red,
                textColor: Colors.white,
                text: AppLocalizations.of(context).translate('register_info'),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await appComponent
                      .getRepository()
                      .changepassword(ChangePassword(
                        oldPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      ))
                      .then((value) async {
                    setState(() {
                      loading = false;
                    });
                    // _newNumberController.text = result;
                  }).catchError((error) {
                    _showErrorMessage(
                      "خطا در تغییر رمز",
                    );

                    setState(() {
                      loading = false;
                    });
                    print(error);
                  });
                },
              ),
            ),
          ]),
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

  @override
  void dispose() {
    super.dispose();
  }
}

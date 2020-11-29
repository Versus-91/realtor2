import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/authorization/login/custom_button.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //stores:---------------------------------------------------------------------
  UserStore _userStore;
  String label;
  var initialIndex = 0;
  final _formStore = FormStore(appComponent.getRepository());

  @override
  void initState() {
    super.initState();
  }

  //text controllers:-----------------------------------------------------------

  
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);

    if (!_userStore.loading && _userStore.user != null) _userStore.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('change_number'),
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Divider(),
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                 suffix: Icon(Icons.visibility_off) ,
                border: OutlineInputBorder(),
                labelText:
                    AppLocalizations.of(context).translate('old_password'),
              ),
              onChanged: (value) {
                _userStore.setOldPassword(value.toString());
              },
            ),
            Divider(),
             TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:
                    AppLocalizations.of(context).translate('new_password'),
              ),
              onChanged: (value) {
                _userStore.setNewPassword(value.toString());
              },
            ),
            Divider(),
             TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(

                border: OutlineInputBorder(),
                labelText:
                    AppLocalizations.of(context).translate('confirm_password'),
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
                color: Colors.red,
                textColor: Colors.white,
                text: AppLocalizations.of(context).translate('register_info'),
                onPressed: () async {
                  _formStore.updeteUser();
                },
              ),
            ),
          ]),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

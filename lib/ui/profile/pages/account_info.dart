import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/authorization/login/custom_button.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class AcountInfoScreen extends StatefulWidget {
  @override
  _AcountInfoScreenState createState() => _AcountInfoScreenState();
}

class _AcountInfoScreenState extends State<AcountInfoScreen>
    with TickerProviderStateMixin {
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
  TextEditingController _familyController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
          AppLocalizations.of(context).translate('my_details'),
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
        if (_userStore.user != null) {
          _userEmailController.text = _userStore.user.email;
          _userNameController.text = _userStore.user.name;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(
                controller: _userEmailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate('user_email'),
                ),
                onChanged: (value) {
                  _formStore.setUserLogin(_userEmailController.text);
                },
              ),
              Divider(),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).translate('Name'),
                      ),
                      onChanged: (value) {
                        _formStore.setName(_nameController.text);
                      },
                    ),
                  ),
                  VerticalDivider(),
                  Flexible(
                    child: TextField(
                      controller: _familyController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).translate('family'),
                      ),
                      onChanged: (value) {
                        _formStore.setFamily(_familyController.text);
                      },
                    ),
                  ),
                ],
              ),
              Divider(),
              TextField(
                controller: _numberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      AppLocalizations.of(context).translate('user_Number'),
                ),
                onChanged: (value) {
                  _formStore.setNumber(value.toString());
                },
              ),
              Divider(),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)
                            .translate('chang_user_password'),
                      ),
                      onChanged: (value) {
                        _formStore.setPassword(_passwordController.text);
                      },
                    ),
                  ),
                ],
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
        } else {
         Container();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

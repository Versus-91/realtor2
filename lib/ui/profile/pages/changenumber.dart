import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/authorization/login/custom_button.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChangeNumber extends StatefulWidget {
  @override
  _ChangeNumberState createState() => _ChangeNumberState();
}

class _ChangeNumberState extends State<ChangeNumber>
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

  TextEditingController _numberController = TextEditingController();

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

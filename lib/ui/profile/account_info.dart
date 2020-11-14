import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/form/post_form.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/login/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final _store = PostFormStore(appComponent.getRepository());
  @override
  void initState() {
    super.initState();
    label = 'انتخاب تاریخ زمان';
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
          "مشخصات من",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(FontAwesomeIcons.infoCircle),
          )
        ],
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
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextField(
              controller: _userEmailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "ایمیل",
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
                      labelText: 'نام',
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
                      labelText: 'نام خانوادگی',
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
                labelText: 'شماره همراه',
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
                      labelText: 'تغییر رمز',
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
                text: 'ثبت',
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

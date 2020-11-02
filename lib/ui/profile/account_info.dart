import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/ui/login/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AcountInfoScreen extends StatefulWidget {
  @override
  _AcountInfoScreenState createState() => _AcountInfoScreenState();
}

class _AcountInfoScreenState extends State<AcountInfoScreen>
    with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------
  PostStore _postStore;
  String label;
  var initialIndex = 0;
  @override
  void initState() {
    super.initState();
    label = 'انتخاب تاریخ زمان';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _postStore = Provider.of(context);
    // check to see if already called api
    if (!_postStore.loading) {
      _postStore.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "اطلاعات کاربری",
          style: TextStyle(color: Colors.white,fontSize: 20),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "ایمیل",
          ),
        ),
        Divider(),
        Row(
          children: [
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'نام',
                ),
              ),
            ),
            VerticalDivider(),
            Flexible(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'نام خانوادگی',
                ),
              ),
            ),
          ],
        ),
        Divider(),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'شماره همراه',
          ),
        ),
        Divider(),
        Row(
          children: [
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'جنسیت',
                ),
              ),
            ),
            VerticalDivider(),
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'تغییر رمز',
                ),
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
            onPressed: () {},
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

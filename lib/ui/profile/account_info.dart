import 'package:boilerplate/stores/post/post_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

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
        backgroundColor: Colors.red,
        elevation: 0.0,
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
                  labelText: 'تاریخ تولد',
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

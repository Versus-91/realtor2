import 'dart:ui';

import 'package:boilerplate/main.dart';
import 'package:boilerplate/ui/home/propertycrads.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------
  bool loading = true;
  var initialIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context).translate('favarite_posts'),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
          child: Material(
            child: _buildListView(),
          ),
        ),
        // _navbarsection(),
      ],
    );
  }

  Widget _buildListView() {
    // if (loading == true) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // } else {
    //   if
    // }

    return FutureBuilder(
      future: appComponent.getRepository().getFavoritesList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("assets/images/404.png"),
              ),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              return PropertyCrad(post: snapshot.data[position]);
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

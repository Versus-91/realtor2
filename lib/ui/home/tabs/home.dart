import 'dart:ui';

import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class UserScreen extends StatefulWidget {
  UserScreen(
      {Key key, this.title, this.userStore, this.postStore, this.tabController})
      : super(key: key);
  final String title;
  final UserStore userStore;
  final PostStore postStore;
  final TabController tabController;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with TickerProviderStateMixin {
  AnimationController _rippleAnimationController;
  bool loggedIn = false;
  @override
  void initState() {
    super.initState();
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );
    getUserLogin();
  }

  void getUserLogin() async {
    var sharePerf = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = sharePerf.getBool(Preferences.is_logged_in) || false;
    });
    if (loggedIn == true) {
      if (widget.userStore.user == null) widget.userStore.getUser();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'خانه',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
          padding:
              const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "جست و جو های اخیر",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  Container(
                      decoration: new BoxDecoration(
                      image: new DecorationImage(
                    image: new AssetImage("assets/images/cloud.png"),
                    fit: BoxFit.fill,
                  )),
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topRight,
                    child: _buildListView(),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2.08,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                    image: new AssetImage("assets/images/bg11.png"),
                    fit: BoxFit.fill,
                  )),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    label: Text('ارسال آگهی'),
                    // icon: Icon(Icons.send),
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildListView() {
    return FutureBuilder(
      future: appComponent.getRepository().getSearchesList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
            AppLocalizations.of(context).translate('home_tv_no_post_found'),
          ));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              return ListTile(
                trailing: InkWell(
                  child: Icon(Icons.delete),
                  onTap: () async {
                    await appComponent
                        .getRepository()
                        .removeSearch(snapshot.data[position].id);
                    setState(() {
                      appComponent.getRepository().getSearchesList();
                    });
                  },
                ),
                title: InkWell(child: createLabel(snapshot.data[position])),
                onTap: () async {
                  var request = PostRequest(
                      maxPrice: snapshot.data[position].maxPrice?.floor(),
                      minPrice: snapshot.data[position].minPrice?.floor(),
                      minArea: 0,
                      maxArea: snapshot.data[position].maxArea?.floor(),
                      district: snapshot.data[position].district,
                      districtName: snapshot.data[position].districtName,
                      city: snapshot.data[position].city,
                      cityName: snapshot.data[position].cityName,
                      bedCount: snapshot.data[position].bedCount,
                      category: snapshot.data[position].category,
                      categoryName: snapshot.data[position].categoryName,
                      types: snapshot.data[position]?.types,
                      amenities: snapshot.data[position]?.amenities);
                  await widget.postStore
                      .getPosts(request: request)
                      .then((value) {
                    widget.tabController.animateTo(1);
                  });
                },
              );
            },
          );
        }
      },
    );
  }

  Text createLabel(dynamic data) {
    String text = data.categoryName;

    if (data.districtName != null) {
      text += "- " + data.districtName;
    } else if (data.cityName != null) {
      text += "- " + data.cityName;
    }
    return Text(text);
  }
}
import 'dart:ui';

import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class UserScreen extends StatefulWidget {
  UserScreen(
      {Key key, this.title, this.userStore, this.postStore, this.filterForm})
      : super(key: key);
  final String title;
  final UserStore userStore;
  final PostStore postStore;
  final FilterFormStore filterForm;

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
    var isLoggedIn = await appComponent.getRepository().isLoggedIn ?? false;
    setState(() {
      loggedIn = isLoggedIn;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context).translate('home'),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate('recent_search'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topRight,
                  child: _buildListView(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 24,
            child: Container(
              height: MediaQuery.of(context).size.height / 3.1,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image: new AssetImage("assets/images/bg11.png"),
                fit: BoxFit.fill,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return FutureBuilder(
      future: appComponent.getRepository().getSearchesList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text(""));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              return Card(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.blue,
                child: ListTile(
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
                        minArea: snapshot.data[position].minArea?.floor(),
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
                    widget.filterForm.mapFilters(request);
                    await widget.postStore
                        .getPosts(request: request)
                        .then((value) {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(Routes.search);
                    });
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  Text createLabel(dynamic data) {
    String text = "";
    if (data.categoryName != null) {
      text += data.categoryName;
    }

    if (data.districtName != null) {
      text += "- " + data.districtName;
    } else {
      text += "/ " + "همه محله ها";
    }
    if (data.cityName != null) {
      text += "- " + data.cityName;
    } else {
      text += "/ " + "همه شهر ها";
    }
    if (data.minDepositPrice != null || data.maxDepositPrice != null) {
      text += "/ " +
          data.minDepositPrice.toString() +
          "-" +
          data.maxDepositPrice.toString() +
          AppLocalizations.of(context).translate('currency_type');
    } else {
      text += "/ " + "همه قیمتها";
    }

    return Text(text);
  }
}

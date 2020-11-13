import 'dart:ui';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/ui/post/postscreen.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLikesScreen extends StatefulWidget {
  @override
  _MyLikesScreenState createState() => _MyLikesScreenState();
}

class _MyLikesScreenState extends State<MyLikesScreen>
    with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------

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
          'آگهی های مورد علاقه',
          style: TextStyle(fontSize: 20, color: Colors.black),
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
    return FutureBuilder(
      future: appComponent.getRepository().getFavoritesList(),
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
              return _buildListItem(snapshot, position);
            },
          );
        }
      },
    );
    // return (_postStore.postList != null && _postStore.postList.posts.length > 0)
    //     ? ListView.builder(
    //         itemCount: _postStore.postList.posts.length,
    //         itemBuilder: (context, position) {
    //           return _buildListItem(position);
    //         },
    //       )
    //     : Center(
    //         child: Text(
    //           AppLocalizations.of(context).translate('home_tv_no_post_found'),
    //         ),
    //       );
  }

  Widget _buildListItem(AsyncSnapshot snapshot, int position) {
    print(snapshot.data[position].toMap());
    return GestureDetector(
      onTap: () {
        Future.delayed(Duration(milliseconds: 0), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.post, (Route<dynamic> route) => false);
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(
                      post: snapshot.data[position],
                    )),
          );
        },
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.black,
          elevation: 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      dense: false,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      title: Text(
                        '${snapshot.data[position].category.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.blue),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.greenAccent,
                              ),
                              Text(
                                '${snapshot.data[position].district.city.name},${snapshot.data[position].district.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ],
                          ),
                          snapshot.data[position].category.name.contains('رهن')
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.greenAccent,
                                    ),
                                    Text(
                                      'رهن: ${snapshot.data[position].deopsit} , اجاره: ${snapshot.data[position].rent}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.greenAccent,
                                    ),
                                    Text(
                                      'قیمت: ${snapshot.data[position].price}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0),
                    width: 130,
                    height: 100,
                    child: snapshot.data[position].images.length > 0
                        ? Image.network(
                            Endpoints.baseUrl +
                                "/" +
                                snapshot.data[position].images[0]?.path,
                            fit: BoxFit.cover,
                          )
                        : Image.asset("assets/images/a.png", fit: BoxFit.cover),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await appComponent
                                    .getRepository()
                                    .removeFavorite(snapshot.data[position]);
                                setState(() {
                                  appComponent
                                      .getRepository()
                                      .getFavoritesList();
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                      Column(
                        children: [
                          Text("متراژ"),
                          Text(
                            '${snapshot.data[position].area}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          )
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                      Column(
                        children: [
                          Text("اتاق خواب"),
                          Text(
                            '${snapshot.data[position].bedroom}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        width: 10,
                        endIndent: 4,
                      ),
                      Column(
                        children: [
                          Text("شناسه آگهی"),
                          Text(
                            '${snapshot.data[position].id}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // General Methods:-----------------------------------------------------------
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

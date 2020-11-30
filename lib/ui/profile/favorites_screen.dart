import 'dart:ui';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/ui/post/post.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
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
          AppLocalizations.of(context).translate('favarite_posts'),
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
              return _buildListItem(snapshot, position);
            },
          );
        }
      },
    );
  }

  Widget _buildListItem(AsyncSnapshot snapshot, int position) {
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
                          snapshot.data[position].category.name.contains(
                                  AppLocalizations.of(context)
                                      .translate('rahn'))
                              ? Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)
                                              .translate('rahn') +
                                          ":" +
                                          '${snapshot.data[position].deopsit} ',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                              .translate('rent') +
                                          ":" +
                                          '${snapshot.data[position].rent}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
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
                                      AppLocalizations.of(context)
                                              .translate('price') +
                                          ":" +
                                          AppLocalizations.of(context)
                                              .transformCurrency(snapshot
                                                  .data[position].price),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
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
                    padding: EdgeInsets.only(top: 2.0, left: 8),
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
                            ),
                            Icon(
                              Icons.share,
                              color: Colors.blue[200],
                            ),
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
                          Text(AppLocalizations.of(context).translate('area')),
                          Text(
                            AppLocalizations.of(context)
                                .transformNumbers(snapshot.data[position].area),
                            style: TextStyle(
                                fontSize: 16,
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
                          Text(AppLocalizations.of(context).translate('bed')),
                          Text(
                             AppLocalizations.of(context)
                                .transformNumbers(snapshot.data[position].bedroom),
                            style: TextStyle(
                                fontSize: 16,
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
                          Text(AppLocalizations.of(context)
                              .translate('post_id')),
                          Text(
                            '${snapshot.data[position].id}',
                            style: TextStyle(
                                fontSize: 16,
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

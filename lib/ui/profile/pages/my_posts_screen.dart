import 'dart:ui';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/ui/post/post.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MyPostsScreen extends StatefulWidget {
  @override
  _MyPostsScreenState createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen>
    with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------
  PostStore _postStore;

  var initialIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _postStore = Provider.of(context);
    // check to see if already called api
    if (!_postStore.loading && _postStore.userPostList == null) {
      _postStore.getUserPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('my_posts'),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.red,
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
          child: _buildMainContent(),
        ),
        _handleErrorMessage(),
        // _navbarsection(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _postStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: _buildListView(),
                color: Colors.white,
              );
      },
    );
  }

  Widget _buildListView() {
    return (_postStore.userPostList != null &&
            _postStore.userPostList.posts.length > 0)
        ? ListView.builder(
            itemCount: _postStore.userPostList.posts.length,
            itemBuilder: (context, position) {
              return _buildListItem(position);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(int position) {
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
                      post: _postStore.userPostList.posts[position],
                    )),
          );
        },
        child: Card(
          color: Colors.white,
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
                      selectedTileColor: Colors.red[100],
                      dense: false,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      title: Text(
                        '${_postStore.userPostList.posts[position].category.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(color: Colors.blue),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_postStore.userPostList.posts[position].district.city.name},${_postStore.userPostList.posts[position].district.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          _postStore.userPostList.posts[position].category.name
                                  .contains('رهن')
                              ? Column(
                                  children: [
                                    Text(
                                      'رهن:' +
                                          AppLocalizations.of(context)
                                              .transformCurrency(_postStore
                                                  .userPostList
                                                  .posts[position]
                                                  .deopsit),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                    Text(
                                      'اجاره:' +
                                          AppLocalizations.of(context)
                                              .transformCurrency(_postStore
                                                  .userPostList
                                                  .posts[position]
                                                  .rent),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ],
                                )
                              : Text(
                                  'قیمت:' +
                                      AppLocalizations.of(context)
                                          .transformCurrency(_postStore
                                              .userPostList
                                              .posts[position]
                                              .rent),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 6),
                    width: 130,
                    height: 110,
                    child:
                        _postStore.userPostList.posts[position].images.length >
                                0
                            ? Image.network(
                                Endpoints.baseUrl +
                                    "/" +
                                    _postStore.userPostList.posts[position]
                                        .images[0]?.path,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/placeholder.png",
                                fit: BoxFit.cover),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.favorite), onPressed: null),
                            IconButton(
                                icon: Icon(Icons.share), onPressed: null),
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: null),
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
                          Text(
                            "متراژ",
                            style: TextStyle(color: Colors.grey.withOpacity(1)),
                          ),
                          Text(
                            AppLocalizations.of(context).transformNumbers(
                                _postStore.userPostList.posts[position].area),
                            style: TextStyle(
                              fontSize: 14,
                            ),
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
                          Text(
                            "اتاق خواب",
                            style: TextStyle(color: Colors.grey.withOpacity(1)),
                          ),
                          Text(
                            AppLocalizations.of(context).transformNumbers(
                                _postStore
                                    .userPostList.posts[position].bedroom),
                            style: TextStyle(
                              fontSize: 14,
                            ),
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
                          Text(
                            "شناسه آگهی",
                            style: TextStyle(color: Colors.grey.withOpacity(1)),
                          ),
                          Text(
                            AppLocalizations.of(context).transformNumbers(
                                _postStore.userPostList.posts[position].id),
                            style: TextStyle(
                              fontSize: 14,
                            ),
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

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_postStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_postStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
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

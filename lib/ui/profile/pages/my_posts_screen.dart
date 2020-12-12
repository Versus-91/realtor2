import 'dart:ui';

import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/ui/home/propertycrads.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
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
    if (!_postStore.loadingUserPosts) {
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
            ? Center(child: CircularProgressIndicator())
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
              return PropertyCrad(
                post: _postStore.userPostList.posts[position],
                isEdditing: true,
              );
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
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

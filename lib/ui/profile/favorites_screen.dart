import 'dart:ui';

import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/ui/home/propertycrads.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  //stores:---------------------------------------------------------------------
  static const _pageSize = 2;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await appComponent
          .getRepository()
          .getFavoritesList(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
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
      body: PagedListView<int, Post>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          itemBuilder: (context, item, index) => PropertyCrad(
            post: item,
          ),
        ),
      ),
    );
  }

  // app bar methods:-----------------------------------------------------------

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
          child: Material(
              // child: _buildListView(),
              ),
        ),
        // _navbarsection(),
      ],
    );
  }

  // Widget _buildListView() {
  //   return FutureBuilder(
  //     future: appComponent.getRepository().getFavoritesList(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState != ConnectionState.done) {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //       if (!snapshot.hasData) {
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Center(
  //               child: Image.asset("assets/images/404.png"),
  //             ),
  //           ],
  //         );
  //       } else {
  //         return ListView.builder(
  //           itemCount: snapshot.data.length,
  //           itemBuilder: (context, position) {
  //             return PropertyCrad(
  //                 post: Post.fromMap(snapshot.data[position]["post"]));
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

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
  static const _pageSize = 10;
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
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, Post>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                child: Text("ایتمی پیدا نشد"),
              );
            },
            firstPageErrorIndicatorBuilder: (context) {
              return Column(
                children: [
                  Padding(padding: const EdgeInsets.all(8.0)),
                  RaisedButton.icon(
                    color: Colors.lightBlueAccent,
                    icon: Icon(Icons.refresh),
                    label: Text('تلاش مجدد'),
                    onPressed: () => _pagingController.refresh(),
                  ),
                  Center(
                    child: Text("خطا در دریافت اطلاعات"),
                  ),
                ],
              );
            },
            itemBuilder: (context, item, index) {
              return PropertyCrad(
                post: item,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

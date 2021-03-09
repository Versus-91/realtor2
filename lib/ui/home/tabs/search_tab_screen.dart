import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/search/list_theme.dart';
import 'package:boilerplate/ui/search/search.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/post_placeholder.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../propertycrads.dart';

class SearchTabScreen extends StatefulWidget {
  @override
  _SearchTabScreenState createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  final ScrollController _scrollController = ScrollController();
  PostStore _postStore;
  FilterFormStore _filterForm;
  bool _loadingMore;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postStore = Provider.of<PostStore>(context);
    _filterForm = Provider.of<FilterFormStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context).translate('posts'),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        actions: [
          Row(
            children: [
              Observer(
                builder: (context) {
                  return _postStore.postList != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate('count_post') +
                                AppLocalizations.of(context).transformNumbers(
                                    _postStore.postList.totalCount.toString()),
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                    .translate('count_post') +
                                '${'N/A'}',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                            ),
                          ));
                },
              ),
              SizedBox(
                width: 8,
              ),
            ],
          )
        ],
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Observer(
                    builder: (context) {
                      if (_postStore.loading == true) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (_postStore.postList != null) {
                          return NestedScrollView(
                            controller: _scrollController,
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[
                                SliverPersistentHeader(
                                  pinned: true,
                                  floating: true,
                                  delegate: ContestTabHeader(
                                    getFilterBarUI(),
                                  ),
                                ),
                              ];
                            },
                            body: RefreshIndicator(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 70),
                                child: IncrementallyLoadingListView(
                                  loadMore: () async {
                                    var request = _filterForm.applyFilters(
                                        paginate: true);
                                    await _postStore.loadNextPage(
                                        request: request);
                                  },
                                  onLoadMore: () {
                                    setState(() {
                                      _loadingMore = true;
                                    });
                                  },
                                  onLoadMoreFinished: () {
                                    setState(() {
                                      _loadingMore = false;
                                    });
                                  },
                                  hasMore: () =>
                                      _postStore.postList.posts.length <
                                      _postStore.postList.totalCount,
                                  itemCount: () =>
                                      _postStore.postList.posts.length,
                                  itemBuilder: (context, index) {
                                    if (index ==
                                            _postStore.postList.posts.length -
                                                1 &&
                                        (_loadingMore ?? false)) {
                                      return Column(
                                        children: [
                                          PropertyCrad(
                                              post: _postStore
                                                  .postList.posts[index]),
                                          PlaceholderPostCard()
                                        ],
                                      );
                                    }
                                    return PropertyCrad(
                                        post: _postStore.postList.posts[index]);
                                  },
                                ),
                              ),
                              onRefresh: () async {
                                await _postStore.getPosts(
                                    request: _filterForm.applyFilters());
                              },
                            ),
                          );
                        } else {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/search.png"),
                                SizedBox(
                                  height: 10,
                                ),
                                RaisedButton.icon(
                                  color: Colors.green[400],
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)
                                        .translate('search'),
                                  ),
                                  onPressed: () {
                                    openFilterScreen();
                                  },
                                  icon: Icon(Icons.search),
                                )
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          _handleErrorMessage(),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      _postStore.postList != null &&
                              _postStore.postList.totalCount > 0
                          ? RaisedButton.icon(
                              onPressed: () {
                                var request = _filterForm.applyFilters();
                                appComponent
                                    .getRepository()
                                    .saveSearch(request)
                                    .then((value) {
                                  FlushbarHelper.createSuccess(
                                      message: 'ذخیره شد.');
                                }).catchError((err) {
                                  FlushbarHelper.createError(
                                      message: 'خطا در ذخیره سازی');
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              label: Text(
                                AppLocalizations.of(context)
                                    .translate('savesearch'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                ),
                              ),
                              icon: Icon(
                                Icons.bookmark,
                                color: Colors.blue,
                              ),
                              textColor: Colors.black,
                              splashColor: Colors.blue,
                              color: Colors.white,
                            )
                          : SizedBox.shrink(),
                      RaisedButton.icon(
                        onPressed: () {
                          openFilterScreen();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        label: Text(
                          AppLocalizations.of(context).translate('filter'),
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                          ),
                        ),
                        icon: Icon(
                          Icons.tune,
                          color: HotelAppTheme.buildLightTheme().primaryColor,
                        ),
                        textColor: Colors.black,
                        splashColor: Colors.red,
                        color: Colors.red[50],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // const Positioned(
        //   top: 0,
        //   left: 0,
        //   right: 0,
        //   child: Divider(
        //     height: 1,
        //   ),
        // )
      ],
    );
  }

  void openFilterScreen() {
    FocusScope.of(context).requestFocus(FocusNode());
    pushNewScreen(context,
        withNavBar: false,
        screen: SearchScreen(
          filterForm: _filterForm,
          postStore: _postStore,
        ));
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

  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        Flushbar(
          flushbarPosition:FlushbarPosition.TOP,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          message: message,
          icon: Icon(
            Icons.warning,
            size: 28.0,
            color: Colors.red[300],
          ),
          leftBarIndicatorColor: Colors.red[300],
          duration: const Duration(seconds: 3),
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

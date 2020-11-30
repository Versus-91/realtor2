import 'package:boilerplate/data/local/datasources/search_datasource.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/ui/search/search.dart';
import 'package:boilerplate/ui/search/list_theme.dart';
import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../propertycrads.dart';

class SearchTabScreen extends StatefulWidget {
  @override
  _SearchTabScreenState createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  final ScrollController _scrollController = ScrollController();
  PostStore _postStore;
  SearchDataSource _searchDataSource;
  FilterFormStore _filterForm = FilterFormStore();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postStore = Provider.of<PostStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                getAppBarUI(),
                Expanded(
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
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
                    body: Observer(
                      builder: (context) {
                        if (_postStore.loading == true) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (_postStore.postList != null) {
                            return NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                    if (_postStore.postList.totalCount >
                                        _postStore.page * _postStore.pageSize) {
                                      _postStore.loadNextPage();
                                      var request = _filterForm.applyFilters(
                                          paginate: true);
                                      _postStore.getPosts(request: request);
                                    } else {
                                      print('already at final page');
                                    }
                                  }
                                  return true;
                                },
                                child: PropertyCrads(
                                  postsList: _postStore.postList,
                                ));
                          } else {
                            return Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/search.png"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: MediaQuery.of(context).size.height / 5,
                                  right: MediaQuery.of(context).size.width / 3,
                                  child: RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Colors.transparent)),
                                    label: Text(
                                      AppLocalizations.of(context)
                                          .translate('search'),
                                    ),
                                    onPressed: () {
                                      openFilterScreen();
                                    },
                                    icon: Icon(Icons.search),
                                  ),
                                )
                              ],
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),

                // Observer(builder: (context) {
                //   if (_filterForm.loading) {
                //     _filterRequest = _filterForm.applyFilters();
                //     _postStore.getPosts(request: _filterRequest);
                //     _filterForm.loading = false;
                //     return SizedBox.shrink();
                //   }
                //   return SizedBox.shrink();
                // })
              ],
            ),
          ),
          _handleErrorMessage(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 15, bottom: 10),
              child: FloatingActionButton(
                heroTag: 'saveSearchButton',
                child: Icon(Icons.save),
                onPressed: () {
                  // if (request != null) {
                  //   await _searchDataSource.insert(request);
                  // }
                },
              ),
            ),
          ),
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
            height: 24,
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
                Expanded(child: Observer(
                  builder: (context) {
                    return _postStore.postList != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)
                                      .translate('count_post') +
                                  AppLocalizations.of(context).transformNumbers(
                                      _postStore.postList.posts?.length),
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
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
                )),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      openFilterScreen();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context).translate('filter'),
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(Icons.tune,
                              color:
                                  HotelAppTheme.buildLightTheme().primaryColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void openFilterScreen() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => SearchScreen(
                filterForm: _filterForm,
                postStore: _postStore,
              ),
          fullscreenDialog: true),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 10),
        child: Row(
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('posts'),
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
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

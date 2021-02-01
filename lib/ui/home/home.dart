import 'package:boilerplate/main.dart';
import 'package:boilerplate/stores/form/filter_form.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/home/tabs/search_tab_screen.dart';
import 'package:boilerplate/ui/home/tabs/user_screen.dart';
import 'package:boilerplate/ui/post/createPost.dart';
import 'package:boilerplate/ui/profile/favorites_screen.dart';
import 'package:boilerplate/ui/profile/pages/settings.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _hideNavBar;

  //stores:---------------------------------------------------------------------
  UserStore _userStore;
  PostStore _postStore;
  FilterFormStore _filterForm;
  PersistentTabController _controller;
  bool loggedIn = false;

  Future<Null> getSharedPrefs() async {
    var isLoggedIn = await appComponent.getRepository().isLoggedIn ?? false;
    setState(() {
      loggedIn = isLoggedIn;
    });
  }

  @override
  void initState() {
    super.initState();
    _hideNavBar = false;
    _controller = PersistentTabController(initialIndex: 0);
    getSharedPrefs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores

    _userStore = Provider.of<UserStore>(context);
    _postStore = Provider.of<PostStore>(context);
    _filterForm = Provider.of<FilterFormStore>(context);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: AppLocalizations.of(context).translate('home'),
        activeColor: Colors.blue,
        inactiveColor: Colors.blueAccent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: AppLocalizations.of(context).translate('search'),
        activeColor: Colors.purpleAccent,
        inactiveColor: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: AppLocalizations.of(context).translate('add_post'),
        activeColor: Colors.green,
        inactiveColor: Colors.green,
        activeColorAlternate: Colors.green,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: AppLocalizations.of(context).translate('favarits'),
        activeColor: Colors.redAccent,
        inactiveColor: Colors.redAccent,
        activeColorAlternate: Colors.red,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: AppLocalizations.of(context).translate('settings'),
        activeColor: Colors.black,
        inactiveColor: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _buildScreens = [
      UserScreen(
        userStore: _userStore,
        postStore: _postStore,
        filterForm: _filterForm,
      ),
      SearchTabScreen(),
      CreatePostScreen(),
      FavoritesScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: PersistentTabView(
        context,
        onItemSelected: (int index) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        controller: _controller,
        screens: _buildScreens,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.only(top: 10.0),
        popActionScreens: PopActionScreensType.once,

        bottomScreenMargin: 0.0,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: Routes.routes,
        ),
        onWillPop: () async {
          await showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) => Container(
              height: 50.0,
              width: 50.0,
              color: Colors.white,
              child: RaisedButton(
                child: Text("خروج "),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
            ),
          );
          return false;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.indigo,
            borderRadius: BorderRadius.horizontal()),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style9, // Choose the nav bar style with this property
      ),
    );
  }

  // General Methods:-----------------------------------------------------------

  @override
  void dispose() {
    super.dispose();
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

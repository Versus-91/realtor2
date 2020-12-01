import 'package:boilerplate/models/Nvigation/bottom_nav.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/home/tabs/user_screen.dart';
import 'package:boilerplate/ui/home/tabs/search_tab_screen.dart';
import 'package:boilerplate/ui/post/createPost.dart';
import 'package:boilerplate/ui/profile/favorites_screen.dart';
import 'package:boilerplate/ui/profile/pages/info.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/sharedpref/constants/preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller;
  bool _hideNavBar;

  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_nav_bar');
  //stores:---------------------------------------------------------------------
  UserStore _userStore;
  PostStore _postStore;

  int _screenNumber = 0;
  List<BottomNav> navItems;

  bool loggedIn = false;
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = prefs.getBool(Preferences.is_logged_in) ?? false;
    });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: AppLocalizations.of(context).translate('home'),
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: AppLocalizations.of(context).translate('search'),
        activeColor: Colors.orange,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: AppLocalizations.of(context).translate('add_post'),
        activeColor: Colors.teal,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: AppLocalizations.of(context).translate('favarits'),
        activeColor: Colors.deepOrange,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: AppLocalizations.of(context).translate('settings'),
        activeColor: Colors.indigo,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      UserScreen(
        userStore: _userStore,
        postStore: _postStore,
      ),
      SearchTabScreen(),
      CreatePostScreen(),
      FavoritesScreen(),
      SettingsScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
    getSharedPrefs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores

    _userStore = Provider.of<UserStore>(context);
    _postStore = Provider.of<PostStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        controller: _controller,
        screens: _buildScreens(),
        confineInSafeArea: true,
        itemCount: 5,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
        ),
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
        // customWidget: BottomNavStyle1(
        //   items: _navBarsItems(),
        //   onItemSelected: (index) {
        //     setState(() {
        //       _controller.index = index; // THIS IS CRITICAL!! Don't miss it!
        //     });
        //   },
        //   selectedIndex: _controller.index,
        // ),
        items: _navBarsItems(),
        onItemSelected: (index) {
          setState(() {
            _controller.index = index; // THIS IS CRITICAL!! Don't miss it!
          });
        },

        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property
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

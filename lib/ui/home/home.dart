import 'package:boilerplate/models/Nvigation/bottom_nav.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/home/tabs/user_screen.dart';
import 'package:boilerplate/ui/home/tabs/search_tab_screen.dart';
import 'package:boilerplate/ui/post/createPost.dart';
import 'package:boilerplate/ui/profile/favorites_screen.dart';
import 'package:boilerplate/ui/profile/profile.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/sharedpref/constants/preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void initState() {
    super.initState();

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
    if (navItems == null)
      navItems = [
        BottomNav(
          screen: UserScreen(
            userStore: _userStore,
            postStore: _postStore,
          ),
          navIcon: Icon(
            Icons.home,
          ),
          title:   AppLocalizations.of(context).translate('home'),
        ),
        BottomNav(
          screen: SearchTabScreen(),
          navIcon: Icon(
            Icons.search,
          ),
          title:   AppLocalizations.of(context).translate('search'),
        ),
        BottomNav(
          screen: FavoritesScreen(),
          navIcon: Icon(
            Icons.favorite,
          ),
          title:  AppLocalizations.of(context).translate('favarits'),
        ),
        BottomNav(
          screen: ProfilePage(),
          navIcon: Icon(
            Icons.person,
          ),
          title:   AppLocalizations.of(context).translate('profile'),
        )
      ];
    return Scaffold(
      appBar: EmptyAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(),
            ),
          );
        },
        tooltip:   AppLocalizations.of(context).translate('send_post'),
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      body: navItems[_screenNumber].screen,
      bottomNavigationBar: BottomNavigationBar(
        key: globalKey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _screenNumber,
        onTap: (i) => setState(() {
          _screenNumber = i;
        }), // this will be set when a new tab is tapped
        items: navItems
            .map((navItem) => BottomNavigationBarItem(
                  icon: navItem.navIcon,
                  label: navItem.title,
                ))
            .toList(),
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

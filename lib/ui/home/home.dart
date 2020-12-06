import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/home/tabs/user_screen.dart';
import 'package:boilerplate/ui/home/tabs/search_tab_screen.dart';
import 'package:boilerplate/ui/post/a.dart';
import 'package:boilerplate/ui/post/createPost.dart';
import 'package:boilerplate/ui/profile/favorites_screen.dart';
import 'package:boilerplate/ui/profile/pages/settings.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/google_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/sharedpref/constants/preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //stores:---------------------------------------------------------------------
  UserStore _userStore;
  PostStore _postStore;

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
    List<Widget> _buildScreens = [
      UserScreen(
        userStore: _userStore,
        postStore: _postStore,
      ),
      SearchTabScreen(),
      CreatePostScreen(),
      FavoritesScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: _buildScreens.elementAt(_selectedIndex),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 1,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  duration: Duration(milliseconds: 500),
                  tabBackgroundColor: Colors.grey[800],
                  tabs: [
                    GButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                      },
                      iconActiveColor: Colors.blue,
                      iconColor: Colors.black,
                      textColor: Colors.blue,
                      backgroundColor: Colors.blue.withOpacity(.2),
                      icon: Icons.home,
                      text: AppLocalizations.of(context).translate("home"),
                    ),
                    GButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                      },
                      iconActiveColor: Colors.amber[600],
                      iconColor: Colors.black,
                      textColor: Colors.amber[600],
                      backgroundColor: Colors.amber[600].withOpacity(.2),
                      iconSize: 24,
                      icon: Icons.search,
                      text: AppLocalizations.of(context).translate("search"),
                    ),
                    GButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                      },
                      iconActiveColor: Colors.teal,
                      iconColor: Colors.black,
                      textColor: Colors.teal,
                      backgroundColor: Colors.teal.withOpacity(.2),
                      icon: Icons.add,
                      text: AppLocalizations.of(context).translate("add_post"),
                    ),
                    GButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                      },
                      iconActiveColor: Colors.pink,
                      iconColor: Colors.black,
                      textColor: Colors.pink,
                      backgroundColor: Colors.pink.withOpacity(.2),
                      icon: Icons.favorite,
                      text: AppLocalizations.of(context).translate("favarits"),
                    ),
                    GButton(
                      iconActiveColor: Colors.purple,
                      iconColor: Colors.black,
                      textColor: Colors.purple,
                      backgroundColor: Colors.purple.withOpacity(.2),
                      iconSize: 24,
                      icon: Icons.settings,
                      text: AppLocalizations.of(context).translate("settings"),
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
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

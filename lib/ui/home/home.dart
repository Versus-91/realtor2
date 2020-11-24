import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/models/Nvigation/bottom_nav.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/home/tabs/user_screen.dart';
import 'package:boilerplate/ui/home/tabs/search_tab_screen.dart';
import 'package:boilerplate/ui/profile/favorites_screen.dart';
import 'package:boilerplate/ui/profile/pages/a.dart';
import 'package:boilerplate/ui/profile/profile.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/sharedpref/constants/preferences.dart';
import '../../utils/locale/app_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------
  UserStore _userStore;
  PostStore _postStore;
  int _screenNumber = 0;
  List<BottomNav> navItems;
  LanguageStore _languageStore;
  ThemeStore _themeStore;
  AnimationController _rippleAnimationController;
  bool loggedIn = false;
  var initialIndex = 0;
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = prefs.getBool(Preferences.is_logged_in) ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );
  
    getSharedPrefs();
    navItems = [
      BottomNav(
        screen: UserScreen(
          userStore: _userStore,
          postStore: _postStore,
        ),
        navIcon: Icon(
          Icons.home,
        ),
        title: 'خانه',
      ),
      BottomNav(
        screen: SearchTabScreen(),
        navIcon: Icon(
          Icons.search,
        ),
        title: 'جستجو',
      ),
      BottomNav(
        screen: MyPage(),
        navIcon: Icon(
          Icons.favorite,
        ),
        title: 'علاقه مندی ها',
      ),
      BottomNav(
        screen: ProfilePage(),
        navIcon: Icon(
          Icons.person,
        ),
        title: 'پروفایل',
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _userStore = Provider.of<UserStore>(context);
    _postStore = Provider.of<PostStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'ارسال آگهی',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      body: navItems[_screenNumber].screen,
      bottomNavigationBar: BottomNavigationBar(
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
      // drawer: GFDrawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       GFDrawerHeader(
      //         decoration: BoxDecoration(
      //             gradient: LinearGradient(
      //                 begin: Alignment.topRight,
      //                 end: Alignment.bottomLeft,
      //                 colors: [Colors.red[400], Colors.red[100]])),
      //         currentAccountPicture: GFAvatar(
      //           radius: 80.0,
      //           backgroundImage: NetworkImage(
      //               "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg"),
      //         ),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             // Text('${}'),
      //             // Text('${user.email}'),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.search),
      //         title: Text('جست و جو'),
      //         onTap: () {
      //           Navigator.of(context).pushNamed(Routes.search);
      //         },
      //       ),
      //       // ListTile(
      //       //   leading: Icon(Icons.language),
      //       //   title: Text('تغییر زبان'),
      //       //   onTap: () {
      //       //     _buildLanguageDialog();
      //       //   },
      //       // ),
      //       if (loggedIn == true) ...[
      //         ListTile(
      //           leading: Icon(Icons.add),
      //           title: Text('افزودن آگهی'),
      //           onTap: () {
      //             Navigator.of(context).pushNamed(Routes.createpost);
      //           },
      //         )
      //       ],
      //       ListTile(
      //         leading: Icon(Icons.exit_to_app),
      //         title: loggedIn ? Text('خروج') : Text('ورود'),
      //         onTap: () {
      //           if (loggedIn) {
      //             SharedPreferences.getInstance().then((preference) async {
      //               preference.setBool(Preferences.is_logged_in, false);
      //               preference.remove(Preferences.auth_token);
      //               _userStore.setLoginState(false);
      //               await _rippleAnimationController.forward();
      //               Navigator.of(context).pushReplacementNamed(Routes.login);
      //             });
      //           } else {
      //             Navigator.of(context).pushReplacementNamed(Routes.login);
      //           }
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      //  GFTabBar(
      //   labelColor: Colors.black,
      //   tabBarColor: Colors.white,
      //   unselectedLabelColor: Colors.grey,
      //   tabBarHeight: 50,
      //   length: 4,
      //   indicatorColor: Colors.transparent,
      //   controller: _tabbarController,
      //   tabs: [
      //     Tab(
      //       icon: Icon(FontAwesomeIcons.home),
      //     ),
      //     Tab(
      //       icon: Icon(FontAwesomeIcons.list),
      //     ),
      //     Tab(
      //       icon: Icon(FontAwesomeIcons.heart),
      //     ),
      //     Tab(
      //       icon: Icon(FontAwesomeIcons.userCircle),
      //     ),
      //   ],
      // ),
    );
  }

  // body methods:--------------------------------------------------------------
  // Widget _buildBody() {
  //   return Stack(
  //     children: <Widget>[
  //       GFTabBarView(controller: _tabbarController, children: <Widget>[
  //         Container(
  //           child: UserScreen(
  //               userStore: _userStore,
  //               postStore: _postStore,
  //               tabController: _tabbarController),
  //         ),
  //         Container(child: SearchTabScreen()),
  //         Container(
  //           child: FavoritesScreen(),
  //         ),
  //         Container(
  //           child: ProfilePage(),
  //         ),
  //       ]),
  //     ],
  //   );
  // }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
    });
  }

  // General Methods:-----------------------------------------------------------

  @override
  void dispose() {
    //_tabbarController.dispose();
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

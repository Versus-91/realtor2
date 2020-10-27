import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/profile/My_Likes.dart';
import 'package:boilerplate/ui/profile/account_info.dart';
import 'package:boilerplate/ui/profile/colors.dart';
import 'package:boilerplate/ui/profile/my_info.dart';
import 'package:boilerplate/ui/profile/opaque_image.dart';
import 'package:boilerplate/ui/profile/profile_info_big_card.dart';
import 'package:boilerplate/ui/profile/profile_info_card.dart';
import 'package:boilerplate/ui/profile/text_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loggedIn = false;
  UserStore _userStore;
  AnimationController _rippleAnimationController;
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = prefs.getBool(Preferences.is_logged_in) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Stack(
                  children: <Widget>[
                    OpaqueImage(
                      imageUrl: "assets/images/house1.jpg",
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "پروفایل من",
                                    textAlign: TextAlign.right,
                                    style: headingTextStyle,
                                  ),
                                  loggedIn
                                      ? FlatButton(
                                          onPressed: () {
                                            {
                                              SharedPreferences.getInstance()
                                                  .then((preference) async {
                                                preference.setBool(
                                                    Preferences.is_logged_in,
                                                    false);
                                                preference.remove(
                                                    Preferences.auth_token);
                                                _userStore.setLoginState(false);
                                                await _rippleAnimationController
                                                    .forward();
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        Routes.login);
                                              });
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.power_settings_new,
                                                size: 30,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(2.0),
                                              ),
                                              Text("خروج",
                                                  style: whiteNameTextStyle),
                                            ],
                                          ))
                                      : FlatButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    Routes.login);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.login_rounded,
                                                size: 30,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(2.0),
                                              ),
                                              Text(
                                                "ورود",
                                                style: whiteNameTextStyle,
                                              ),
                                            ],
                                          )),
                                ],
                              ),
                            ),
                            MyInfo(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.only(top: 50),
                  color: Colors.white,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AcountInfoScreen(),
                                ),
                              );
                            },
                            child: ProfileInfoBigCard(
                              secondText: "اطلاعات کاربری",
                              icon: Icon(
                                Icons.account_circle,
                                size: 32,
                                color: blueColor,
                              ),
                            ),
                          ),
                          ProfileInfoBigCard(
                            secondText: "آگهی های من",
                            icon: Image.asset(
                              "assets/icons/checklist.png",
                              width: 32,
                              color: blueColor,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyLikesScreen(),
                                ),
                              );
                            },
                            child: ProfileInfoBigCard(
                              secondText: "آگهی های مورد علاقه",
                              icon: Icon(
                                Icons.favorite,
                                size: 32,
                                color: blueColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.createpost);
                            },
                            child: ProfileInfoBigCard(
                              secondText: "افزودن آگهی",
                              icon: Icon(
                                Icons.post_add,
                                size: 32,
                                color: blueColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          ProfileInfoBigCard(
                            secondText: "طرح های موجود",
                            icon: Icon(
                              Icons.remove_red_eye,
                              size: 32,
                              color: blueColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyLikesScreen(),
                                ),
                              );
                            },
                            child: ProfileInfoBigCard(
                              secondText: "درباره ما",
                              icon: Icon(
                                Icons.help_outline,
                                size: 32,
                                color: blueColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * (4 / 10) - 80 / 2,
            left: 16,
            right: 16,
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ProfileInfoCard(firstText: "54%", secondText: ""),
                  SizedBox(
                    width: 10,
                  ),
                  ProfileInfoCard(
                    hasImage: true,
                    imagePath: "assets/icons/pulse.png",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ProfileInfoCard(firstText: "152", secondText: "آگهی های من"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/plugin/cropper.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/user/user_store.dart';

import 'package:boilerplate/ui/profile/pages/aboute.dart';
import 'package:boilerplate/ui/profile/pages/account_info.dart';
import 'package:boilerplate/ui/profile/constants/colors.dart';
import 'package:boilerplate/ui/profile/pages/changenumber.dart';
import 'package:boilerplate/ui/profile/pages/changepassword.dart';
import 'package:boilerplate/ui/profile/pages/info.dart';
import 'package:boilerplate/ui/profile/pages/my_posts_screen.dart';
import 'package:boilerplate/ui/profile/constants/opaque_image.dart';
import 'package:boilerplate/ui/profile/profile_info_big_card.dart';
import 'package:boilerplate/ui/profile/constants/radial_progress.dart';
import 'package:boilerplate/ui/profile/constants/rounded_image.dart';
import 'package:boilerplate/ui/profile/constants/text_style.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  File imageFile;
  bool loggedIn = false;
  UserStore _userStore;
  AnimationController _rippleAnimationController;
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = prefs.getBool(Preferences.is_logged_in) ?? false;
    });
  }

  final cropKey = GlobalKey<ImgCropState>();

  Future getImage(type) async {
    //عکس =جوابیکه از فیوچر میاد
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File result = await Navigator.of(context)
        .pushNamed(Routes.crop, arguments: {'image': image});
    var multiPartAvatarImage = await MultipartFile.fromFile(result.path);

    _userStore
        .uploadAvatarImage(multiPartAvatarImage)
        .then((value) => _userStore.getUser())
        .catchError((error) => Flushbar(
              message:
                  AppLocalizations.of(context).translate('error_upload_avatar'),
              title: AppLocalizations.of(context).translate('error_upload'),
            ));
  }

  void getUserLogin() async {
    var sharePerf = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = sharePerf.getBool(Preferences.is_logged_in) || false;
    });
    if (loggedIn == true) {
      if (_userStore.user == null) _userStore.getUser();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
    getUserLogin();
  }

  @override
  void initState() {
    super.initState();
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Stack(
                  children: <Widget>[
                    OpaqueImage(
                      imageUrl: "assets/images/house1.jpg",
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('profile'),
                                    textAlign: TextAlign.right,
                                    style: headingTextStyle,
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        {
                                          SharedPreferences.getInstance()
                                              .then((preference) async {
                                            preference.setBool(
                                                Preferences.is_logged_in,
                                                false);
                                            preference
                                                .remove(Preferences.auth_token);
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
                                          Text(
                                              AppLocalizations.of(context)
                                                  .translate('logout'),
                                              style: whiteNameTextStyle),
                                          Divider(),
                                          Icon(
                                            Icons.logout,
                                            color: Colors.red[50],
                                            size: 30,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Observer(
                              builder: (context) {
                                return _userStore.user != null
                                    ? Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            RadialProgress(
                                                width: 4,
                                                goalCompleted: 0.9,
                                                child: _userStore
                                                            ?.user.avatar ==
                                                        null
                                                    ? Image.asset(
                                                        "assets/images/no-profile.jpg",
                                                        fit: BoxFit.cover,
                                                        width: 140,
                                                        height: 140,
                                                      )
                                                    : RoundedImage(
                                                        path:
                                                            Endpoints.baseUrl +
                                                                "/" +
                                                                _userStore.user
                                                                    .avatar,
                                                        size: Size.fromWidth(
                                                            120.0),
                                                      )),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  _userStore.user.email,
                                                  style: whiteNameTextStyle,
                                                ),
                                                Text(
                                                  _userStore.user.name,
                                                  style:
                                                      whiteSubHeadingTextStyle,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Image.asset(
                                        "assets/images/no-profile.jpg",
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    loggedIn == true
                        ? Positioned(
                            top: 150,
                            right: 110,
                            child: Container(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                icon: Icon(Icons.add_a_photo),
                                color: Colors.white,
                                splashRadius: 20,
                                onPressed: () async {
                                  getImage(ImageSource.gallery);
                                },
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  color: Color(0xfff3f3f4),
                  child: SingleChildScrollView(
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
                                secondText: AppLocalizations.of(context)
                                    .translate('account_info'),
                                icon: Icon(
                                  Icons.account_circle,
                                  size: 25,
                                  color: blueColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: loggedIn == true
                                  ? () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MyPostsScreen(),
                                        ),
                                      );
                                    }
                                  : () {},
                              child: ProfileInfoBigCard(
                                secondText: AppLocalizations.of(context)
                                    .translate('my_posts'),
                                icon: Image.asset(
                                  "assets/icons/checklist.png",
                                  width: 25,
                                  color: blueColor,
                                ),
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
                                    builder: (context) => ChangeNumber(),
                                  ),
                                );
                              },
                              child: ProfileInfoBigCard(
                                secondText: AppLocalizations.of(context)
                                    .translate('change_number'),
                                icon: Icon(
                                  Icons.vpn_key,
                                  size: 25,
                                  color: blueColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePasswordScreen(),
                                  ),
                                );
                              },
                              child: ProfileInfoBigCard(
                                secondText: AppLocalizations.of(context)
                                    .translate('change_password'),
                                icon: Icon(
                                  Icons.mobile_friendly,
                                  size: 25,
                                  color: blueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            ProfileInfoBigCard(
                              secondText: AppLocalizations.of(context)
                                  .translate('plants'),
                              icon: Icon(
                                Icons.remove_red_eye,
                                size: 25,
                                color: blueColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AboutScreen(),
                                  ),
                                );
                              },
                              child: ProfileInfoBigCard(
                                secondText: AppLocalizations.of(context)
                                    .translate('about_us'),
                                icon: Icon(
                                  Icons.help_outline,
                                  size: 25,
                                  color: blueColor,
                                ),
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
                                    builder: (context) => SettingsScreen(),
                                  ),
                                );
                              },
                              child: ProfileInfoBigCard(
                                secondText: "پروفایل",
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  size: 25,
                                  color: blueColor,
                                ),
                              ),
                            ),
                            SizedBox.shrink()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

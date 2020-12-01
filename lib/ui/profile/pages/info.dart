import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/ui/profile/pages/aboute.dart';
import 'package:boilerplate/ui/profile/pages/my_posts_screen.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:settings_ui/settings_ui.dart';
import 'dart:async';
import 'dart:io';
import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/plugin/cropper.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
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

    dynamic result = await Navigator.of(context)
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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('settings'),
        ),
      ),
      body: SettingsList(
        backgroundColor: Colors.white,
        sections: [
          CustomSection(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 8),
                  child: Observer(
                    builder: (context) {
                      return _userStore.user != null
                          ? InkWell(
                              onTap: () async {
                                getImage(ImageSource.gallery);
                              },
                              child: _userStore?.user.avatar == null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.red,
                                      child: CircleAvatar(
                                        radius: 48,
                                        backgroundImage: AssetImage(
                                          "assets/images/no-profile.jpg",
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.red,
                                      child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage(
                                            Endpoints.baseUrl +
                                                "/" +
                                                _userStore.user.avatar,
                                          )),
                                    ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.red,
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage: AssetImage(
                                  "assets/images/no-profile.jpg",
                                ),
                              ),
                            );
                    },
                  ),
                ),
                Text(
                  _userStore.user != null
                      ? "سلام" + _userStore.user.name
                      : "سلام",
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
          SettingsSection(
            tiles: [
              SettingsTile(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.changeInfo);
                },
                title: AppLocalizations.of(context).translate("my_details"),
                leading: Icon(Icons.person),
                trailing: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                ),
              )
            ],
          ),
          SettingsSection(
            tiles: [
              SettingsTile.switchTile(
                title: AppLocalizations.of(context).translate("notifications"),
                enabled: true,
                leading: Icon(Icons.notifications_active),
                switchValue: true,
                onToggle: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: 'مدیریت آگهی',
            tiles: [
              SettingsTile(
                  onTap: loggedIn == true
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyPostsScreen(),
                            ),
                          );
                        }
                      : () {},
                  title: AppLocalizations.of(context).translate("my_posts"),
                  leading: Icon(Icons.description)),
              SettingsTile(
                  title: AppLocalizations.of(context).translate("plants"),
                  leading: Icon(Icons.collections_bookmark)),
              SettingsTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),
                      ),
                    );
                  },
                  title: AppLocalizations.of(context).translate("about_us"),
                  leading: Icon(Icons.info)),
              SettingsTile(
                  onTap: () {
                    {
                      SharedPreferences.getInstance().then((preference) async {
                        preference.setBool(Preferences.is_logged_in, false);
                        preference.remove(Preferences.auth_token);
                        _userStore.setLoginState(false);
                        await _rippleAnimationController.forward();
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.login);
                      });
                    }
                  },
                  title: AppLocalizations.of(context).translate("logout"),
                  leading: Icon(Icons.exit_to_app)),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:boilerplate/constants/constants.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/plugin/cropper.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/profile/pages/aboute.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  File imageFile;
  bool loggedIn = false;
  bool _isActive = true;
  UserStore _userStore;
  final _imagePicker = ImagePicker();
  AnimationController _rippleAnimationController;
  Future<Null> getSharedPrefs() async {
    setState(() async {
      loggedIn = await appComponent.getRepository().isLoggedIn ?? false;
    });
  }

  final cropKey = GlobalKey<ImgCropState>();

  Future getImage(type) async {
    var image = await _imagePicker.getImage(source: ImageSource.gallery);
    if (image == null) return;

    dynamic result = await Navigator.of(context, rootNavigator: true)
        .pushNamed(Routes.crop, arguments: {'image': File(image.path)});

    var multiPartAvatarImage = await MultipartFile.fromFile(result.path);

    _userStore.uploadAvatarImage(multiPartAvatarImage).then((value) async {
      Future.delayed(Duration(seconds: 1), () async {
        await _userStore.getUser();
      });
    }).catchError((error) => Flushbar(
          message:
              AppLocalizations.of(context).translate('error_upload_avatar'),
          title: AppLocalizations.of(context).translate('error_upload'),
        ));
  }

  void getUserLogin() async {
    setState(() async {
      loggedIn = await appComponent.getRepository().isLoggedIn ?? false;
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
    return Observer(
      builder: (_) {
        return Scaffold(
          body: SettingsList(
            backgroundColor: Colors.white,
            sections: [
              CustomSection(child: Observer(builder: (context) {
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 8),
                        child: _userStore.user != null
                            ? InkWell(
                                onTap: () async {
                                  getImage(ImageSource.gallery);
                                },
                                child: _userStore?.user?.avatar == null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.blueGrey,
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: AssetImage(
                                            "assets/images/no-profile.jpg",
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.blueGrey,
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
                                backgroundColor: Colors.blueGrey,
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage: AssetImage(
                                    "assets/images/no-profile.jpg",
                                  ),
                                ),
                              )),
                    Text(
                      _userStore.user != null
                          ? " سلام " + _userStore.user.name
                          : "",
                      style: TextStyle(color: Color(0xFF777777)),
                    ),
                  ],
                );
              })),
              SettingsSection(
                tiles: [
                  SettingsTile(
                    onTap: _userStore.user != null
                        ? () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(Routes.changeInfo);
                          }
                        : () {},
                    title: AppLocalizations.of(context).translate("my_details"),
                    leading: Icon(Icons.person),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.keyboard_arrow_left),
                    //   onPressed: () {},
                    // ),
                  )
                ],
              ),
              SettingsSection(
                tiles: [
                  SettingsTile.switchTile(
                    switchActiveColor: Colors.lightGreen,
                    title:
                        AppLocalizations.of(context).translate("notifications"),
                    enabled: true,
                    leading: Icon(Icons.notifications_active),
                    switchValue: _isActive,
                    onToggle: (value) {
                      setState(() {
                        _isActive = !_isActive;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'مدیریت آگهی',
                tiles: [
                  SettingsTile(
                      onTap: loggedIn == true
                          ? () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(Routes.userPosts);
                            }
                          : () {},
                      title: AppLocalizations.of(context).translate("my_posts"),
                      leading: Icon(Icons.description)),
                  // SettingsTile(
                  //     title: AppLocalizations.of(context).translate("plants"),
                  //     leading: Icon(Icons.collections_bookmark)),
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
                      onTap: () async {
                        {
                          if (loggedIn == true) {
                            await Logout(context);
                          } else {
                            await _rippleAnimationController.forward();
                            Navigator.of(context, rootNavigator: true)
                                .pushNamedAndRemoveUntil(Routes.login,
                                    (Route<dynamic> route) => false);
                            //   context,
                            //   screen: LoginPage(),
                            //   withNavBar: false,
                            //   settings: null,
                            // );
                          }
                        }
                      },
                      title: loggedIn == true
                          ? AppLocalizations.of(context).translate("logout")
                          : AppLocalizations.of(context)
                              .translate("login_btn_sign_in"),
                      leading: Icon(Icons.exit_to_app)),
                ],
              ),
              CustomSection(
                  child: Center(
                child: Image.asset(
                  'assets/icons/settings.png',
                  height: 200,
                  width: 50,
                  color: Color(0xFF777777),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Future Logout(BuildContext context) async {
    return await appComponent.getRepository().logOut();
  }
}

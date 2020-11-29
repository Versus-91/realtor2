import 'package:boilerplate/ui/profile/pages/language_screen.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        AppLocalizations.of(context).translate('my_details'),
      )),
      body: SettingsList(
        // backgroundColor: Colors.orange,
        sections: [
          SettingsSection(
            title: 'اطلاعات حساب',
            tiles: [
              SettingsTile(title: 'نام', leading: Icon(Icons.email)),
              SettingsTile(title: ' شماره', leading: Icon(Icons.phone)),
              SettingsTile(title: 'ایمیل', leading: Icon(Icons.email)),
            ],
          ),
          SettingsSection(
            title: 'امنیت',
            tiles: [
              SettingsTile.switchTile(
                title: 'تغییر رمز',
                leading: Icon(Icons.lock),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile.switchTile(
                title: 'فعالسازی اعلان ها',
                enabled: notificationsEnabled,
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
                  title: 'آگهی های من', leading: Icon(Icons.description)),
              SettingsTile(
                  title: 'طرح های موجود',
                  leading: Icon(Icons.collections_bookmark)),
              SettingsTile(title: 'درباره ما', leading: Icon(Icons.info)),
              SettingsTile(title: 'خروج', leading: Icon(Icons.exit_to_app)),
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 8),
                  child: Image.asset(
                    'assets/icons/settings.png',
                    height: 50,
                    width: 50,
                    color: Color(0xFF777777),
                  ),
                ),
                Text(
                  'Version: 2.4.0 (287)',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

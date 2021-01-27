import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/models/notification/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager {
  PushNotificationsManager._();
  factory PushNotificationsManager() {
    _instance.init();
    return _instance;
  }

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      int userId;
      await SharedPreferences.getInstance().then((prefs) {
        userId = prefs.getInt(Preferences.userId) ?? 0;
      });
      if (userId != null && userId != 0) {
        await appComponent
            .getRepository()
            .saveNotification(Notification(userId: userId, firebaseId: token));
      }
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}

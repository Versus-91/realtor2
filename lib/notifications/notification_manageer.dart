import 'package:boilerplate/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  PushNotificationsManager._();
  factory PushNotificationsManager() {
    _instance.init();
    return _instance;
  }

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  Future<String> get fcmToken => _firebaseMessaging.getToken();
  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          //_showItemDialog(message);
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          // _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          // _navigateToItemDetail(message);
        },
      );
      ;

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      int userId;
      await appComponent.getRepository().userId.then((val) {
        userId = val ?? 0;
      });
      if (userId != null && userId != 0) {
        await appComponent.getRepository().saveNotification(token);
      }
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}

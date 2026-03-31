import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_path.dart';
import '../api/config.dart';
import '../app/home/notification/controller/notification_controller.dart';
import 'package:get/get.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /*
  ==============================
  1️⃣ Get and Register Token
  ==============================
  */
  static Future<void> initFCM() async {

    final NotificationController notificationController =
    Get.put(NotificationController(), permanent: true);
    // Request permission (important for iOS)
    await _messaging.requestPermission();

    String? token = await _messaging.getToken();

    if (token != null) {
      await registerToken(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground FCM received: ${message.notification?.title}");

      // Call your function
      notificationController.fetchNotificationsUnreadCount();
    });

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      registerToken(newToken);
    });
  }

  /*
  ==============================
  2️⃣ Register Token to Backend
  ==============================
  */
  static Future<void> registerToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      final response = await Config.dio.post(
        '/${ApiPath.registerDeviceForNotification}',
        data: {"fcm_token": token, "device_type": "android", "user_id": userId},
      );

      if (response.statusCode == 200) {
        print("FCM token registered successfully");
      } else {
        print("FCM registration failed: ${response.data}");
      }
    } catch (e) {
      print("FCM error: $e");
    }
  }
}

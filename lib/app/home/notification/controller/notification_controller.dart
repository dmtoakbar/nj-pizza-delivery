import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/api_path.dart';
import '../../../../api/config.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;

  late String? userId;

  @override
  void onInit() {
    fetchNotificationsUnreadCount();
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotificationsUnreadCount() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('user_id');
      final response = await Config.dio.post(
        '/${ApiPath.getUnreadCountNotification}',
        data: {"user_id": userId},
      );

      if (response.data['success']) {
        unreadCount.value = response.data['unread_count'];
        update();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('user_id');
      final response = await Config.dio.post(
        '/${ApiPath.getNotificationList}',
        data: {"user_id": userId},
      );

      if (response.data['success']) {
        notifications.value =
            (response.data['data'] as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    await Config.dio.post(
      '/${ApiPath.markNotificationRead}',
      data: {"notification_id": id, 'user_id': userId},
    );

    notifications.removeWhere((e) => e.id == id);
    unreadCount.value = notifications.length;
  }
}

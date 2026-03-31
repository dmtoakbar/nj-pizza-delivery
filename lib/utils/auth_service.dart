import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/app_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../constants/user_profile_data.dart';

class AuthService {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';
  static const _keyToken = 'auth_token';
  static const _keyTokenExpiry = 'token_expiry';

  static Future<void> saveLogin({
    required String userId,
    required String name,
    required String email,
    required String token,
    required String expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyTokenExpiry, expiresAt);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userProfileData.dataLoaded = false;
    Get.offAndToNamed(Routes.LOGIN);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<bool> checkLoginAndRedirect() async {
    final loggedIn = await isLoggedIn();

    if (!loggedIn) {
      AppToast.error("Login Required\nPlease login to proceed");
      Get.offAllNamed(Routes.ONBOARD);
      return false;
    }
    return true;
  }
}

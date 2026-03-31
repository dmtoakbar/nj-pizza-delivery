import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/constants/user_profile_data.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/app_toast.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/api_path.dart';
import '../../../../api/config.dart';

class ProfileController extends GetxController {
  // ───────────── Text Controllers ─────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  RxString name = ''.obs;
  RxString address = ''.obs;

  final isProfileLoading = true.obs;
  final isUpdating = false.obs;
  final isAccountDeleting = false.obs;

  RxBool profileUploaded = false.obs;

  void _showError(String message) {
    AppToast.error(message);
  }

  void _showSuccess(String message) {
    AppToast.success(message);
  }

  Future<void> loadProfile() async {
    if (profileUploaded.value) return;
    try {
      isProfileLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';
      bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (userId.isEmpty) {
        isProfileLoading.value = false;
        if(isLoggedIn)_showError("Failed to load profile login again");
        return;
      }

      final response = await Config.dio.post(
        '/${ApiPath.getUser}',
        data: {'user_id': userId},
      );

      final Map<String, dynamic> data =
          response.data is String
              ? jsonDecode(response.data)
              : Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        final user = data['data'];
        nameController.text = user['name'] ?? '';
        emailController.text = user['email'] ?? '';
        phoneController.text = user['phone'] ?? '';
        addressController.text = user['address'] ?? '';
        profileUploaded.value = true;

        name.value = user['name'];
        address.value = user['address'];
        return;
      }
      _showError(data['message'] ?? "Profile load failed");
    } catch (e) {
      _showError("Failed to load profile");
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      _showError("Please fill all required fields");
      return;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneController.text.trim())) {
      _showError("Enter a valid phone number");
      return;
    }

    try {
      isUpdating.value = true;

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        _showError("Session expired. Please login again.");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final response = await Config.dio.post(
        '/${ApiPath.updateUser}',
        data: {
          'user_id': userId,
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
        },
      );

      final Map<String, dynamic> data =
          response.data is String
              ? jsonDecode(response.data)
              : Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        _showSuccess(data['message'] ?? "Profile updated successfully");

        profileUploaded.value = false;
        await loadProfile();
        return;
      }

      _showError(data['message'] ?? "Profile update failed");
    } catch (e) {
      debugPrint('❌ UPDATE PROFILE ERROR: $e');
      _showError("Failed to update profile");
    } finally {
      isUpdating.value = false;
    }
  }

  // delete user account

  Future<void> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';

      if (userId.isEmpty) {
        _showError("Session expired. Please login again.");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      if (emailController.text.trim().isEmpty) {
        _showError("Email not found. Cannot delete account.");
        return;
      }

      isAccountDeleting.value = true;

      final response = await Config.dio.post(
        '/${ApiPath.deleteUser}',
        data: {'user_id': userId, 'email': emailController.text.trim()},
      );

      final Map<String, dynamic> data =
          response.data is String
              ? jsonDecode(response.data)
              : Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        _showSuccess(data['message'] ?? "Account deleted successfully");

        await AuthService.logout();
        return;
      }

      _showError(data['message'] ?? "Account deletion failed");
    } catch (e) {
      debugPrint('❌ DELETE USER ERROR: $e');
      _showError("Failed to delete account");
    } finally {
      isAccountDeleting.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}

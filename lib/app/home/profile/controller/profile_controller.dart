import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nj_pizza_delivery/constants/user_profile_data.dart';
import 'package:nj_pizza_delivery/routes/app_routes.dart';
import 'package:nj_pizza_delivery/utils/auth_service.dart';

class ProfileController extends GetxController {
  // ───────────── Text Controllers ─────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final isProfileLoading = true.obs;
  final isUpdating = false.obs;

  RxBool profileUploaded = false.obs;

  String? uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  Future<void> loadProfile() async {
    if (profileUploaded.value) return;
    try {
      isProfileLoading.value = true;

      uid = await AuthService.getUid();

      if (uid == null) {
        _showError("Session expired. Please login again.");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        _showError("Profile not found");
        return;
      }

      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      addressController.text = data['address'] ?? '';
      profileUploaded.value = true;
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

      if (uid == null) {
        _showError("Session expired");
        return;
      }

      await _firestore.collection('users').doc(uid).update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      userProfileData.updateData(
        name: nameController.text.trim(),
        mobile: '${phoneController.text.trim()}',
        email: emailController.text.trim(),
        address: addressController.text.trim(),
      );

      _showSuccess("Profile updated successfully");
    } catch (e) {
      _showError("Failed to update profile");
    } finally {
      isUpdating.value = false;
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

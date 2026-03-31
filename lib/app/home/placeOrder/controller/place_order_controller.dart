import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/address_model.dart';

class PlaceOrderController extends GetxController {
  /// User inputs
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  /// Address sheet inputs
  final label = 'Home'.obs; // reactive label
  final addressNameController = TextEditingController();
  final addressPhoneController = TextEditingController();
  final addressController = TextEditingController();

  /// Address list
  final addresses = <AddressModel>[].obs;
  final selectedIndex = 0.obs;

  /// SharedPreferences key
  static const _prefKey = 'saved_addresses';

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  /// ================= ADD / UPDATE =================
  void addAddress(AddressModel model) {
    addresses.add(model);
    selectedIndex.value = addresses.length - 1;
    label.value = model.label;
    saveAddresses();
  }

  void updateAddress(int index, AddressModel model) {
    addresses[index] = model;
    if (selectedIndex.value == index) {
      label.value = model.label;
    }
    saveAddresses();
  }

  /// ================= SELECT / DELETE =================
  void selectAddress(int index) {
    selectedIndex.value = index;
    final a = addresses[index];
    nameController.text = a.name;
    phoneController.text = a.phone;
    label.value = a.label;
  }

  void deleteAddress(int index) {
    addresses.removeAt(index);
    if (addresses.isNotEmpty) {
      selectAddress(0);
    } else {
      nameController.clear();
      phoneController.clear();
    }
    saveAddresses();
  }

  /// ================= PERSISTENCE =================
  Future<void> saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final list = addresses.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_prefKey, list);
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefKey) ?? [];

    if (list.isNotEmpty) {
      addresses.value =
          list.map((e) => AddressModel.fromJson(jsonDecode(e))).toList();
      selectAddress(0);
    } else {
      /// No saved addresses: load profile address (if available)
      loadProfileAddress();
    }
  }

  /// ================= PROFILE ADDRESS =================
  void loadProfileAddress() {
    final profile = Get.find<ProfileController>();

    final profileName = profile.nameController.text.trim();
    final profilePhone = profile.phoneController.text.trim();
    final profileAddress = profile.addressController.text.trim();

    // Only add if all fields are non-empty
    if (profileName.isNotEmpty &&
        profilePhone.isNotEmpty &&
        profileAddress.isNotEmpty) {
      final model = AddressModel(
        name: profileName,
        phone: profilePhone,
        address: profileAddress,
        label: 'Home',
      );

      addresses.value = [model];
      selectAddress(0);
    } else {
      // No initial address
      addresses.clear();
      selectedIndex.value = -1;
    }
  }
}

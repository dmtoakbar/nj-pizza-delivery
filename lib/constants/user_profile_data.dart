import 'package:nj_pizza_delivery/app/home/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class userProfileData {
  static bool isLoading = false;
  static bool dataLoaded = false;
  static String name = '';
  static String email = '';
  static String mobile = '';
  static String address = '';

  static Future<void> getUserData() async {
    if (dataLoaded) return;

    isLoading = true;
    final controller = Get.find<ProfileController>();

    name = controller.nameController.text.trim();
    email = controller.emailController.text.trim();
    mobile = controller.phoneController.text.trim();
    address = controller.addressController.text.trim();

    isLoading = false;
    dataLoaded = true;
  }

  static void updateData({
    required String name,
    required String mobile,
    required String email,
    required String address,
  }) {
    userProfileData.name = name;
    userProfileData.mobile = mobile;
    userProfileData.email = email;
    userProfileData.address = address;
    dataLoaded = true;
  }
}

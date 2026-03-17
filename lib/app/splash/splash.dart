import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/splash/controller/splash_controller.dart';
import 'package:nj_pizza_delivery/constants/app_strings.dart';
import '../../constants/images_files.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: const BorderSide(color: Color(0xFFEB5525), width: 4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipOval(
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: OverflowBox(
                          maxHeight: 300,
                          maxWidth: 300,
                          child: Image.asset(
                            ImagesFiles.onboardImage,
                            width: 200,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3E2723),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Be Happy With ${AppStrings.appName}!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

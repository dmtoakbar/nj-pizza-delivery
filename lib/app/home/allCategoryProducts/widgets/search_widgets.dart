import 'package:flutter/material.dart';
import 'package:nj_pizza_delivery/app/home/allCategoryProducts/controller/all_category_products_controller.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/allCategoryProducts/controller/search_controller.dart';
import '../../../../constants/images_files.dart';
import '../../widgets/voiceToText/voice_to_text.dart';

class AllCategorySearchWidget extends StatelessWidget {
  AllCategorySearchWidget({super.key});
  final controller = Get.find<AllCategoryProductsController>();
  final searchController = Get.find<AllCategorySearchController>();
  @override
  Widget build(BuildContext context) {
    return _searchBar();
  }

  Widget _searchBar() {
    return Obx(() {
      if (controller.loading.value) {
        return SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Image.asset(ImagesFiles.searchIcon, height: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: searchController.textController,
                  onChanged: searchController.updateSearch,
                  decoration: const InputDecoration(
                    hintText: 'Search food...',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showVoiceRecorderDialog(
                    onDone: (text) {
                      searchController.searchQuery.value = text.trim();
                      searchController.textController.text = text.trim();
                    },
                  );
                },
                child: Image.asset(ImagesFiles.audioIcon, height: 18),
              ),
            ],
          ),
        ),
      );
    });
  }
}

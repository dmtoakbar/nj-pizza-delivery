import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/home/home/controller/search_controller.dart';
import '../../../../constants/images_files.dart';
import '../../widgets/voiceToText/voice_to_text.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({super.key});

  final controller = Get.put(SearchHomeController());
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// SEARCH BOX
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Image.asset(
                  ImagesFiles.searchIcon,
                  height: 18,
                  width: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 10),

                /// TEXT FIELD
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    onChanged: controller.updateSearch,
                    cursorColor: Colors.grey,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: 'Search Food...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                InkWell(
                  onTap: () {
                    showVoiceRecorderDialog(
                      onDone: (text) {
                        controller.searchQuery.value = text.trim();
                        controller.textController.text = text.trim();
                      },
                    );
                  },
                  child: Image.asset(
                    ImagesFiles.audioIcon,
                    height: 18,
                    width: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        _filterSection(),
      ],
    );
  }

  Widget _filterSection() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Obx(
            () => Container(
              constraints: BoxConstraints(maxHeight: Get.height * 0.65),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // ───────── DRAG HANDLE ─────────
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ───────── HEADER ─────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: controller.resetFilters,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEB5525),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  // ───────── CONTENT ─────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('Category'),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              controller.categories.length,
                              (index) {
                                final selected = controller.isCategorySelected(
                                  index,
                                );

                                return InkWell(
                                  borderRadius: BorderRadius.circular(22),
                                  onTap: () => controller.selectCategory(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          selected
                                              ? const Color(0xFFEB5525)
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color:
                                            selected
                                                ? const Color(0xFFEB5525)
                                                : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      controller.categories[index].name,
                                      style: TextStyle(
                                        color:
                                            selected
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ───────── PRICE RANGE ─────────
                          _SectionTitle('Price Range'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: SliderTheme(
                              data: SliderTheme.of(Get.context!).copyWith(
                                activeTrackColor: const Color(0xFFEB5525),
                                inactiveTrackColor: Colors.grey.shade300,

                                thumbColor: const Color(0xFFEB5525),
                                overlayColor: const Color(
                                  0xFFEB5525,
                                ).withOpacity(0.15),

                                rangeThumbShape:
                                    const RoundRangeSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                rangeTrackShape:
                                    const RoundedRectRangeSliderTrackShape(),
                                trackHeight: 4,

                                valueIndicatorColor: const Color(0xFFEB5525),
                                valueIndicatorTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: RangeSlider(
                                values: RangeValues(
                                  controller.minPrice.value,
                                  controller.maxPrice.value,
                                ),
                                min: 0,
                                max: 1000,
                                divisions: 20,
                                labels: RangeLabels(
                                  '₹${controller.minPrice.value.toInt()}',
                                  '₹${controller.maxPrice.value.toInt()}',
                                ),
                                onChanged: (range) {
                                  controller.setPriceRange(
                                    range.start,
                                    range.end,
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ───────── SORT ─────────
                          _SectionTitle('Sort By'),
                          _RadioTile(
                            title: 'Price: Low to High',
                            value: PriceSort.lowToHigh,
                            groupValue: controller.priceSort.value,
                            onChanged: controller.setPriceSort,
                          ),

                          _RadioTile(
                            title: 'Price: High to Low',
                            value: PriceSort.highToLow,
                            groupValue: controller.priceSort.value,
                            onChanged: controller.setPriceSort,
                          ),

                          const SizedBox(height: 24),

                          // ───────── TOGGLES ─────────
                          _SwitchTile(
                            title: 'Popular Only',
                            value: controller.showPopularOnly.value,
                            onChanged: (_) => controller.togglePopular(),
                          ),
                          _SwitchTile(
                            title: 'Featured Only',
                            value: controller.showFeaturedOnly.value,
                            onChanged: (_) => controller.toggleFeatured(),
                          ),

                          SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEB5525),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () => Get.back(),
                                child: const Text(
                                  'Apply Filters',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Image.asset(
        ImagesFiles.filterIcon,
        height: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _SectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _RadioTile<T>({
    required String title,
    required T value,
    required T? groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    final bool isSelected = value == groupValue;

    return RadioListTile<T>(
      contentPadding: EdgeInsets.zero,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,

      // 🎯 IMPORTANT
      selected: isSelected,

      // 🎨 BACKGROUND
      tileColor: Colors.transparent, // unselected bg
      selectedTileColor: const Color(0xFFFFEEE8), // selected bg (light orange)
      // 🎯 RADIO CIRCLE COLOR
      activeColor: const Color(0xFFEB5525),
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFFEB5525); // selected circle
        }
        return Colors.grey; // unselected circle
      }),

      // ✨ RIPPLE / TAP
      overlayColor: MaterialStateProperty.all(
        const Color(0xFFEB5525).withOpacity(0.08),
      ),

      // 📝 TEXT
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isSelected ? const Color(0xFFEB5525) : Colors.black87,
        ),
      ),
    );
  }

  Widget _SwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,

      // 🎯 IMPORTANT
      selected: value,

      // 🎨 BACKGROUND
      tileColor: Colors.transparent,
      selectedTileColor: const Color(0xFFFFEEE8), // light orange
      // 📝 TEXT
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: value ? const Color(0xFFEB5525) : Colors.black87,
        ),
      ),

      // 🔘 SWITCH COLORS
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white, // thumb ON
      activeTrackColor: const Color(0xFFEB5525),
      inactiveThumbColor: Colors.grey.shade400,
      inactiveTrackColor: Colors.grey.shade300,

      // ✨ TAP RIPPLE
      overlayColor: MaterialStateProperty.all(
        const Color(0xFFEB5525).withOpacity(0.08),
      ),
    );
  }
}

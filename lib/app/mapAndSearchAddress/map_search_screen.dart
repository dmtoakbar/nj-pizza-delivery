import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nj_pizza_delivery/app/mapAndSearchAddress/controller/map_search_controller.dart';

class MapSearchScreen extends GetView<MapSearchController> {
  MapSearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // GOOGLE MAP
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    controller.currentPosition.value ??
                    controller.defaultLatLng,
                zoom: 14,
              ),
              onMapCreated: (c) {
                controller.mapController = c;

                if (controller.currentPosition.value != null) {
                  c.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      controller.currentPosition.value!,
                      14,
                    ),
                  );
                }
              },
              markers: controller.markers,

              onTap: (LatLng position) {
                controller.onMapTapped(position);
              },
            ),

            // SEARCH FIELD
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: searchController,
                  onChanged: controller.searchPlaces,
                  decoration: InputDecoration(
                    hintText: "Search location...",
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
            ),
            if (controller.predictions.isNotEmpty)
              Positioned(
                top: 110,
                left: 16,
                right: 16,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.predictions.length,
                      itemBuilder: (context, index) {
                        final item = controller.predictions[index];
                        return ListTile(
                          title: Text(item['description']),
                          onTap: () {
                            controller.selectPlace(item['place_id']);
                            searchController.text = item['description'];
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

            Positioned(
              bottom: 16,
              left: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(controller.currentFormatAddress.value),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Get.back(result: controller.currentFormatAddress.value);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color(0xFFEB5525),
                        ),
                        child: Center(
                          child: Text(
                            "Confirm Address",
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
    );
  }
}

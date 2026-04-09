import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapSearchController extends GetxController {
  final String googleApiKey = dotenv.env['GOOGLE_MAP_API_KEY'] ?? '';
  var predictions = [].obs;
  var isLoading = false.obs;

  GoogleMapController? mapController;
  var markers = <Marker>{}.obs;
  final LatLng defaultLatLng = const LatLng(28.6139, 77.2090);

  var currentPosition = Rxn<LatLng>();

  RxString currentFormatAddress = ''.obs;

  Timer? debounce;

  @override
  void onInit() {
    super.onInit();

    getAddressFromLatLng(defaultLatLng);
    ever(currentPosition, (LatLng? pos) {
      if (pos != null) {
        getAddressFromLatLng(pos);
      }
    });
    getCurrentLocation();
  }

  // GET CURRENT LOCATION
  Future<void> getCurrentLocation() async {
    isLoading.value = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      isLoading.value = false;
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latLng = LatLng(position.latitude, position.longitude);

    currentPosition.value = latLng;

    // Move camera
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));

    // Add marker
    markers.clear();
    markers.add(Marker(markerId: const MarkerId("current"), position: latLng));

    isLoading.value = false;
  }

  void onMapTapped(LatLng position) {
    // Move camera
    mapController?.animateCamera(CameraUpdate.newLatLng(position));

    // Update marker
    markers.clear();
    markers.add(
      Marker(markerId: const MarkerId("selected"), position: position),
    );

    // Save selected position (optional)
    currentPosition.value = position;
  }

  // SEARCH API
  void searchPlaces(String value) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty) {
        predictions.clear();
        return;
      }

      final url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$googleApiKey";

      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);

      predictions.value = data['predictions'];
    });
  }

  // SELECT PLACE
  Future<void> selectPlace(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    final location = data['result']['geometry']['location'];
    final lat = location['lat'];
    final lng = location['lng'];

    final LatLng pos = LatLng(lat, lng);

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));

    markers.clear();
    markers.add(Marker(markerId: const MarkerId("selected"), position: pos));

    predictions.clear();

    getAddressFromLatLng(pos);
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    final address = data['results'][0]['formatted_address'];
    currentFormatAddress.value = address;
  }
}

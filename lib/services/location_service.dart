import 'package:geolocator/geolocator.dart';

class LocationService {
  /// ✅ Request location permission
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false; // ❌ Permission denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // ❌ User permanently denied location
    }

    return true; // ✅ Permission granted
  }

  /// ✅ Get current location if permission is granted
  Future<Position> getCurrentLocation() async {
    bool permissionGranted = await requestLocationPermission();
    if (!permissionGranted) {
      throw Exception("Location permission denied.");
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}


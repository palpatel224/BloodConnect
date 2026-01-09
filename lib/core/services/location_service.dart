import 'package:flutter/foundation.dart';
import '../../core/services/places_service/places_api_service.dart';
import '../../service_locator.dart';

class LocationService {
  final PlacesApiService _placesService;

  LocationService({PlacesApiService? placesService})
      : _placesService = placesService ?? sl<PlacesApiService>();

  Future<Map<String, double>?> getCoordinatesFromPlace(String placeId) async {
    try {
      return await _placesService.getPlaceDetails(placeId);
    } catch (e) {
      debugPrint('Error getting coordinates: $e');
      return null;
    }
  }
}

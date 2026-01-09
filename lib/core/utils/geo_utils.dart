import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility class for performing geoqueries on Firestore
class GeoUtils {
  /// Earth radius in kilometers
  static const double earthRadiusKm = 6371.0;

  /// Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Calculate distance between two points using the Haversine formula
  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// Create a GeoPoint from latitude and longitude
  static GeoPoint createGeoPoint(double latitude, double longitude) {
    return GeoPoint(latitude, longitude);
  }

  /// Calculate the bounding box for a circular region
  /// Returns [minLat, minLon, maxLat, maxLon]
  static List<double> calculateBoundingBox(
      double centerLat, double centerLon, double radiusInKm) {
    // Rough approximation: 1 degree of latitude = 111 km
    final latDelta = radiusInKm / 111.0;

    // Longitude degrees vary based on latitude
    final lonDelta = radiusInKm / (111.0 * cos(_degreesToRadians(centerLat)));

    return [
      centerLat - latDelta, // minLat
      centerLon - lonDelta, // minLon
      centerLat + latDelta, // maxLat
      centerLon + lonDelta, // maxLon
    ];
  }
}
